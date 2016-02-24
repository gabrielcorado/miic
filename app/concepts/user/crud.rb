# User Concept
class User
  # Create Operation
  class Create < Trailblazer::Operation
    # Include Traiblazer Operation modules
    include Model
    include Representer
    # include Trailblazer::Operation::Responder
    # include Responder

    # Define the model
    model User, :create

    # Define the contract (validation)
    contract do
      # Attributes
      property :name
      property :nickname

      # Validations
      validates :name, presence: true
      validates :nickname, presence: true
      validates_uniqueness_of :nickname
    end

    # Define the representer
    representer User::Representers::Show

    # Process
    def process(params)
      # Validate the model
      validate(params[:user]) do |f|
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
