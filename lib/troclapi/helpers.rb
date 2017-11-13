module Sinatra
  module Troclapi
    module Helpers
      def trocla
        $trocla ||= Trocla.new
      end
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
          _h = error_render("Missing #{k}") if v.empty?
        end
        _h
      end
      def rescue_return(e)
        logger.error e.message
        logger.debug e.backtrace.join("\n")
        error(500, e.message)
      end
      def keys?(keys)
        error(400, 'Missing keys') if keys.nil? || keys.empty?
      end
      def bad_format(trocla_key, format)
        logger.debug "Bad format #{format} for key #{trocla_key}"
        error_render('Bad format')
      end
      def error(code, message)
        halt code, error_render(message).to_json
      end
      def error_render(message)
        { :success => false, :error => message }
      end
    end
  end
end
