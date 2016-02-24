class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Ignore the authenticity token
  skip_before_action :verify_authenticity_token, if: :json_request?

  protected
    def json_request?
      request.format.json?
    end

    # Repond with JSON
    # (https://github.com/apotonick/trailblazer/blob/master/lib/trailblazer/operation/controller.rb#L33)
    def api_respond(operation_class, options={})
      res, op = operation_for!(operation_class, options) { |params| operation_class.run(params) }
      namespace = options.delete(:namespace) || []

      # Return the operation
      return render(json: op) if res

      # Return the errors
      render json: op.errors
    end
end
