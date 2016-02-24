# Test Helper
require 'test_helper'

class PostCRUDTest < ActiveSupport::TestCase
  setup do
    # Admin user
    @user = users(:admin)

    # Important post
    @post = posts(:important)

    # Sample user
    @sample = { post: { content: 'Here come a nice post!', user: { id: @user.id } }.to_json }
  end

  test 'should create' do
    # Check if there is a new post
    assert_difference('Post.count') do
      Post::Create.(@sample)
    end

    # Find the post
    post = Post.last

    # Assertions
    assert_equal 'Here come a nice post!', post.content
    assert_equal @user.id, post.user.id
  end

  test 'should update' do
    # Update the Post
    Post::Update.(
      id: @post.id,
      post: { content: 'This is not that important' }.to_json
    )

    # Reload the post model
    @post.reload

    # Assertions
    assert_equal 'This is not that important', @post.content
  end

  test 'should destroy' do
    # Destroy the post
    assert_difference('Post.count', -1) do
      Post::Destroy.(id: @post.id)
    end

    # Assertions
    assert_equal false, Post.exists?(id: @post.id)
  end
end
