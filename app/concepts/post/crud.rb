# Post Concept
class Post
  # Create Operation
  class Create < Trailblazer::Operation
    # Include Traiblazer Operation modules
    include Model
    include Representer

    # Define the model
    model Post, :create

    # Define the representer
    representer Post::Representers::Show

    # Define the contract (validation)
    contract do
      # Attributes
      property :content
      property :user, populator: -> (fragment:, **) { self.user = User.find(fragment['id']) } do
        property :id
        validates :id, presence: true
      end

      # Validations
      validates :content, presence: true
    end

    # Process
    def process(params)
      # Validate the model
      validate(params[:post]) do |f|
        # Save it
        f.save
      end
    end
  end

  # List operation
  class List < Trailblazer::Operation
    # Include Traiblazer Operation modules
    include Collection
    include Representer

    # Define the representer
    representer User::Representers::List

    # Define an empty process
    def process(*)
    end

    # Model
    def model!(params)
      User.all
    end
  end

  # Show Operation
  class Show < Create
    # Define the model action
    action :find
  end

  # Update Operation
  class Update < Create
    # Define the model action
    action :update
  end

  # Destroy Operation
  class Destroy < Create
    # Define the model action
    action :find

    # Process
    def process(params)
      # Destroy the model
      model.destroy
    end
  end
end
