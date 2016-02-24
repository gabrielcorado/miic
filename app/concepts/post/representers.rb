# Post Concept
class Post
  # Representers Module
  module Representers
    # Show representer
    class Show < Roar::Decorator
      # Define as JSON
      include Roar::JSON

      # Basic attributes
      property :id, render_empty: false
      property :content
      property :user, populator: ::Reform::Form::Populator::External.new do
        property :id
        property :name
        property :nickname
      end
    end

    # List Representer
    class List < Roar::Decorator
      # Define as JSON
      include Roar::JSON

      # Define a collection
      collection :to_a, as: :posts, decorator: Show
    end
  end
end
