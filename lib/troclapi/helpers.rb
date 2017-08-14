module Sinatra
  module Troclapi
    module Helpers
      def authorize!
        redirect(to('/login')) unless session[:user]
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
          request.body.rewind
          JSON.parse request.body.read
        rescue
          {}
        end
      end
      def check_empty(h)
        _h = {}
        h.each do |k,v|
          _h = {'error' => "Missing #{k}", 'success' => false} if v.empty?
        end
        _h
      end
      def rescue_return(e)
        logger.error e.message
        logger.debug e.backtrace.join("\n")
        status 500
        {'error' => e.message, 'success' => false}
      end
      def trocla_get(trocla_key, format, options)
        result = {}
        result = check_empty({'trocla key' => trocla_key, 'format' => format})
        return result unless result.empty?
        begin
          trocla = Trocla.new
          logger.info "#{session[:user]} GET #{trocla_key} #{format}"
          result['value'] = trocla.get_password(
            trocla_key,
            format,
            options
          )
          if result['value'].nil?
            logger.debug "Get value for key #{trocla_key} on format #{format}"
            result = {'error' => 'Key not found on this format', 'success' => false}
          else
            logger.debug "Get value for key #{trocla_key} on format #{format}"
            result['success'] = true
          end
        rescue => e
          result = rescue_return(e)
        end
        result
      end
      def trocla_create(trocla_key, format, options)
        result = {}
        result = check_empty({'trocla key' => trocla_key, 'format' => format})
        return result unless result.empty?
        begin
          trocla = Trocla.new
          logger.info "#{session[:user]} CREATE #{trocla_key} #{format}"
          result['value'] = trocla.password(
            trocla_key,
            format,
            options
          )
          logger.debug "Create key #{trocla_key} on format #{format}"
          result['success'] = true
        rescue => e
          result = rescue_return(e)
        end
        result
      end
      def trocla_delete(trocla_key, format)
        result = {}
        result = check_empty({'trocla key' => trocla_key, 'format' => format})
        return result unless result.empty?
        begin
          trocla = Trocla.new
          logger.info "#{session[:user]} DELETE #{trocla_key} #{format}"
          result['value'] = trocla.delete_password(
            trocla_key,
            format
          )
          if result['value'].nil?
            logger.debug "Delete value for key #{trocla_key} on format #{format} not found"
            result = {'error' => 'Key not found on this format', 'success' => false}
          else
            logger.debug "Delete value for key #{trocla_key} on format #{format}"
            result['success'] = true
          end
        rescue => e
          result = rescue_return(e)
        end
        result
      end
      def trocla_reset(trocla_key, format, options)
        result = {}
        result = check_empty({'trocla key' => trocla_key, 'format' => format})
        return result unless result.empty?
        begin
          trocla = Trocla.new
          logger.info "#{session[:user]} RESET #{trocla_key} #{format}"
          result['value'] = trocla.reset_password(
            trocla_key,
            format,
            options
          )
          result['success'] = true
          logger.debug "Reset value for key #{trocla_key} on format #{format}"
        rescue => e
          result = rescue_return(e)
        end
        result
      end
      def trocla_search(trocla_key)
        result = {}
        result = check_empty({'trocla key' => trocla_key})
        return result unless result.empty?
        begin
          trocla = Trocla.new
          logger.info "#{session[:user]} SEARCH #{trocla_key} #{format}"
          trocla_key.each do |key|
            _search = trocla.search_key(key)
            if _search.empty?
              result[key] = nil
            else
              result[key] = _search
            end
          end
          result['success'] = true
        rescue => e
          result = rescue_return(e)
        end
        result
      end
      def trocla_set(trocla_key, format, value)
        result = {}
        result = check_empty({'trocla key' => trocla_key, 'format' => format, 'value' => value})
        return result unless result.empty?
        begin
          trocla = Trocla.new
          logger.info "#{session[:user]} SET #{trocla_key} #{format}"
          result['value'] = trocla.set_password(
            trocla_key,
            format,
            value
          )
          result['success'] = true
          logger.debug "Set value for key #{trocla_key} on format #{format}"
        rescue => e
          result = rescue_return(e)
        end
        result
      end
    end
  end
end
