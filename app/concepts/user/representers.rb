# User Concept
class User
  # Representers Module
  module Representers
    # Show representer
    class Show < Roar::Decorator
      # Define as JSON
      include Roar::JSON

      # Basic attributes
      property :id, render_empty: false
      property :name
      property :nickname
    end

    # List Representer
    class List < Roar::Decorator
      # Define as JSON
      include Roar::JSON

      # Define a collection
      collection :to_a, as: :users, decorator: Show
    end
  end
end
