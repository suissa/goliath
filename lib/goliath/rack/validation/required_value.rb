require 'goliath/rack/validation_error'

module Goliath
  module Rack
    module Validation
      # Middleware to validate that a given parameter has a specified value.
      #
      # @example
      #  use Goliath::Rack::Validation::RequiredValue, {:key => 'mode', :values => %w(foo bar)}
      #  use Goliath::Rack::Validation::RequiredValue, {:key => 'baz', :values => 'awesome'}
      #
      class RequiredValue
        attr_reader :key, :values

        # Creates the Goliath::Rack::Validation::RequiredValue validator.
        #
        # @param app The app object
        # @param opts [Hash] The options to create the validator with
        # @option opts [String] :key The key to look for in params (default: id)
        # @option opts [String | Array] :values The values to verify are in the params
        # @return [Goliath::Rack::Validation::RequiredValue] The validator
        def initialize(app, opts = {})
          @app = app
          @key = opts[:key] || 'id'
          @values = [opts[:values]].flatten
        end

        def call(env)
          value_valid!(env['params'])
          @app.call(env)
        end

        def value_valid!(params)
          error = false
          if !params.has_key?(key) || params[key].nil? ||
              (params[key].is_a?(String) && params[key] =~ /^\s*$/)
            error = true
          end

          if params[key].is_a?(Array)
            error = true if params[key].empty?

            params[key].each do |k|
              unless values.include?(k)
               error = true
               break
              end
            end
          elsif !values.include?(params[key])
            error = true
          end

          raise Goliath::Validation::Error.new(400, "Provided #{@key} is invalid") if error
        end
      end
    end
  end
end