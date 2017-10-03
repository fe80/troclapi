module Sinatra
  module Troclapi
    module Helpers
      def format?(format)
        if format.nil?
          logger.error 'Missing format, exiting...'
          false
        elsif !Trocla::Formats.available?(format)
          logger.error "Error: The format #{format} is not available"
          false
        else
          true
        end
      end
      def read_json
        begin
          JSON.parse request.body.read
        rescue
          {}
        end
      end
      def check_empty(h)
        _h = {}
        h.each do |k,v|
          _h = {:error => "Missing #{k}", :success => false} if v.empty?
        end
        _h
      end
      def rescue_return(e)
        logger.error e.message
        logger.debug e.backtrace.join("\n")
        error(500, e.message)
      end
      def keys?(keys)
        error(400, 'Missing keys')
      end
      def bad_format(trocla_key, format)
        logger.debug "Bad format #{format} for key #{trocla_key}"
        {'error' => 'Bad format', 'success' => false}
      end
      def error(code, message)
        halt code, { :success => false, :error => message }.to_json
      end
    end
  end
end
