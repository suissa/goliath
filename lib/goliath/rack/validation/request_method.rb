require 'goliath/rack/validation_error'

module Goliath
  module Rack
    module Validation
      # A middleware to validate that the request had a given HTTP method.
      #
      # @example
      #  use Goliath::Rack::Validation::RequestMethod, %w(GET POST)
      #
      class RequestMethod
        attr_reader :methods

        ERROR = 'Invalid request method'

        # Called by the framework to create the Goliath::Rack::Validation::RequestMethod validator
        #
        # @param app The app object
        # @param methods [Array] The accepted request methods
        # @return [Goliath::Rack::Validation::RequestMethod] The validator
        def initialize(app, methods = [])
          @app = app
          @methods = methods
        end

        def call(env)
          raise Goliath::Validation::Error.new(400, ERROR) unless methods.include?(env['REQUEST_METHOD'])
          @app.call(env)
        end
      end
    end
  end
end