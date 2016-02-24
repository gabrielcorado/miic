# Dry validations
require 'reform/form/dry'

# User Concept
class User
  # Redis keys
  FOLLOWING_KEY = 'user:following'
  FOLLOWERS_KEY = 'user:followers'

  # UnFollow contract
  class UnFollowContract < Reform::Form
    # Dry validations
    include Reform::Form::Dry::Validations

    # The property
    property :followed, virtual: true

    # Check if you're already following this User
    validation :followed do
      # Validations
      key(:followed, &:valid_user?)
      key(:followed, &:myself?)

      # Valid user?
      def valid_user?(user_id)
        User.exists? user_id
      end

      # Myself?
      def myself?(user_id)
        form.model.id != user_id
      end

      # Already following the user?
      def following?(user_id)
        !IsFollowing.(form.model, user_id)
      end
    end
  end

  # Follow Contract
  class FollowContract < UnFollowContract
    validation :followed, inherit: true do
      key(:followed, &:following?)
    end
  end

  # Check if the user is following another user
  class IsFollowing
    # Call
    def self.call(follower, followed, errors = nil)
      # Set the users ids
      follower_id = follower.respond_to?(:id) ? follower.id : follower
      followed_id = followed.respond_to?(:id) ? followed.id : followed

      # Get the following user score
      score = $redis.zscore "#{User::FOLLOWING_KEY}:#{follower_id}", followed_id

      # following?
      following = score != nil

      #
      errors.add('follower', 'already following') if !errors.nil? && following

      # Return the flag
      following
    end
  end

  # Follow Operation
  class Follow < Trailblazer::Operation
    # Include Traiblazer Operation modules
    include Model

    # Define the model
    model User, :find

    # Define the contract (validation)
    contract FollowContract

    # Process
    def process(params)
      # Validate the options
      validate(params) do
        # Follow the user
        $redis.zadd "#{User::FOLLOWING_KEY}:#{@model.id}", Time.now.to_i, params[:followed]

        # Set the user as followed
        $redis.zadd "#{User::FOLLOWERS_KEY}:#{params[:followed]}", Time.now.to_i, @model.id
      end
    end
  end

  # Unfollow operation
  class Unfollow < Follow
    # Define the contract (validation)
    contract UnFollowContract

    # Process
    def process(params)
      # Validate the options
      validate(params) do
        # Follow the user
        $redis.zrem "#{User::FOLLOWING_KEY}:#{@model.id}", params[:followed]

        # Set the user as followed
        $redis.zrem "#{User::FOLLOWERS_KEY}:#{params[:followed]}", @model.id
      end
    end
  end

  # Following list
  class Following < Trailblazer::Operation
    # Include Traiblazer Operation modules
    include Collection
    include Representer

    # Define the representer
    representer User::Representers::List

    # Model
    def model!(params)
      # Find all the users that are followed
      users = $redis.zrevrange "#{User::FOLLOWING_KEY}:#{params[:id]}", 0, -1

      # Load users models
      User.where id: users
    end
  end

  # Followers list
  class Followers < Following
    # Model
    def model!(params)
      # Find all the users that are followed
      users = $redis.zrevrange "#{User::FOLLOWERS_KEY}:#{params[:id]}", 0, -1

      # Load users models
      User.where id: users
    end
  end
end
