#
module Api
  #
  class UsersController < ApplicationController
    # Respond to
    respond_to :json

    # Show the most common posts
    def index
      respond User::List
    end

    # Show a user
    def show
      respond User::Show
    end

    # Create a new user
    def create
      api_respond User::Create, is_document: true
    end

    # Update user
    def update
      api_respond User::Update, is_document: true
    end

    # Create a new user
    def destroy
      api_respond User::Destroy
    end

    # Follow a user
    def follow
      # Follow the user
      res, op = User::Follow.run(id: params['user_id'], followed: params['followed'])

      # Check success
      return render(nothing: true, status: :accepted) if res

      # Error
      render json: op.errors
    end

    # Unfollow a user
    def unfollow
      # Follow the user
      res, op = User::Unfollow.run(id: params['user_id'], followed: params['followed'])

      # Check success
      return render(nothing: true, status: :accepted) if res

      # Error
      render json: op.errors
    end

    # Following
    def following
      # Get the followers
      op = User::Following.present(id: params[:user_id])

      # Return it
      respond_with op
    end

    # Following
    def followers
      # Get the followers
      op = User::Followers.present(id: params[:user_id])

      # Return it
      respond_with op
    end
  end
end
