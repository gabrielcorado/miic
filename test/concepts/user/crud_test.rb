# Test Helper
require 'test_helper'

class UserCRUDTest < ActiveSupport::TestCase
  setup do
    # Admin user
    @user = users(:admin)
    @user_params = { user: @user.attributes.to_json }

    # Sample user
    @sample = { user: { name: 'Gabriel Corado', nickname: 'gabrielcorado' }.to_json }
  end

  test 'should create' do
    # Check if there is a new user
    assert_difference('User.count') do
      User::Create.(@sample)
    end
  end

  test 'should update' do
    # Update the user
    User::Update.(
      id: @user.id,
      user: { name: 'A bad admin' }.to_json
    )

    # Reload the user model
    @user.reload

    # Assertions
    assert_equal 'A bad admin', @user.name
    assert_equal 'admin', @user.nickname
  end

  test 'should destroy' do
    # Destroy the user
    assert_difference('User.count', -1) do
      User::Destroy.(id: @user.id)
    end

    # Assertions
    assert_equal false, User.exists?(id: @user.id)
  end
end
