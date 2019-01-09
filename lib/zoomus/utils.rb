module Zoomus
  class Utils

    class << self

      def argument_error(name)
        name ? ArgumentError.new("You must provide #{name}") : ArgumentError.new
      end

      def raise_if_error!(response)
        if response["error"]
          raise Error.new(response["error"]["message"])
        else
          response
        end
      end

      def parse_response(&http_response)
        response = case http_response.call&.code
                   when nil
                     { 'error' => { 'message' => "Could not communicate with Zoom API", 'code' => 500 } }
                   when 200...300
                     http_response.parsed_response
                   when 404, 500...600
                     { 'error' => { 'message' => "API returned error code #{http_response.code}", 'code' => http_response.code } }
                   end
      rescue Net::ReadTimeout
        response = { 'error' => { 'message' => 'Request timeout', 'code' => 504 } }
      ensure
        # Mocked response returns a string
        response.is_a?(Hash) ? response : JSON.parse(response)
      end

      def require_params(params, options)
        params = [params] unless params.is_a? Array
        params.each do |param|
          unless options[param]
            raise argument_error(param.to_s)
            break
          end
        end
      end

      # Dinamically defines bang methods for Actions modules
      def define_bang_methods(klass)
        klass.instance_methods.each do |m|
          klass.send(:define_method, "#{m}!") do |*args|
            Utils.raise_if_error! send(m, *args)
          end
        end
      end

      def extract_options!(array)
        array.last.is_a?(::Hash) ? array.pop : {}
      end

      def process_datetime_params!(params, options)
        params = [params] unless params.is_a? Array
        params.each do |param|
          if options[param] && options[param].kind_of?(Time)
            options[param] = options[param].strftime("%FT%TZ")
          end
        end
        options
      end
    end
  end
end
