# Require roar stuff
require 'roar/decorator'
require 'roar/json'

# Evaluate the Roar Representer
Roar::Representer.module_eval do
  # Add the Rails URL helpers
  include Rails.application.routes.url_helpers

  # Set default options for the URL Helpers
  def default_url_options
    {}
  end
end
