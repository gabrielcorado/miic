# Test Helper
require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  # Setup the tests
  setup do
    # Define the users
    @follower = users(:admin)
    @followed = users(:brian)

    # Possible followers
    @users = [users(:tom), users(:jeff), users(:aaron)]
  end

  #
  test 'follow an user' do
    # Let's follow
    res = User::Follow.run(id: @follower.id, followed: @followed.id)

    # Assertions
    assert_equal true, res[0]
    assert_not_nil $redis.zscore("#{User::FOLLOWING_KEY}:#{@follower.id}", @followed.id)
    assert_not_nil $redis.zscore("#{User::FOLLOWERS_KEY}:#{@followed.id}", @follower.id)
  end

  #
  test 'check if is following a specific user' do
    # Let's follow
    User::Follow.(id: @follower.id, followed: @followed.id)

    # Let's check
    following = User::IsFollowing.call(@follower, @followed)

    # Assertions
    assert_equal true, following
  end

  #
  test 'unfollow an user' do
    # Let's follow
    User::Follow.(id: @follower.id, followed: @followed.id)

    # And then unfollow
    res = User::Unfollow.run(id: @follower.id, followed: @followed.id)

    # Let's check
    following = User::IsFollowing.call(@follower, @followed)

    # Assertions
    assert_equal true, res[0]
    assert_equal false, following
  end

  #
  test 'get the followed users' do
    # Let's follow some users
    @users.each do |followed|
      # Follow the user
      User::Follow.(id: @follower.id, followed: followed.id)
    end

    # Get the following list
    users = User::Following.present(id: @follower.id).model

    # Assertions
    assert_equal @users[0], users[0]
    assert_equal @users[1], users[1]
    assert_equal @users[2], users[2]
  end

  #
  test 'get the user followers list' do
    # Let's follow some users
    @users.each do |follower|
      # Follow the user
      User::Follow.(id: follower.id, followed: @followed.id)
    end

    # Get the following list
    users = User::Followers.present(id: @followed.id).model

    # Assertions
    assert_equal @users[0], users[0]
    assert_equal @users[1], users[1]
    assert_equal @users[2], users[2]
  end
end
