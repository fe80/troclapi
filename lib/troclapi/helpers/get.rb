module Sinatra
  module Troclapi
    module Get
      module Helpers
        def trocla_get(trocla_key, format, options)
          result = {}
          result = check_empty({'trocla key' => trocla_key, 'format' => format})
          return result unless result.empty?
          result[:format] = format
          begin
            trocla = Trocla.new
            logger.info "#{session[:user]} GET #{trocla_key} #{format}"
            result[:value] = trocla.get_password(
              trocla_key,
              format,
              options
            )
            if result[:value].nil?
              logger.debug "Get value for key #{trocla_key} on format #{format}"
              result = {:error => 'Key not found on this format', :success => false}
            else
              logger.debug "Get value for key #{trocla_key} on format #{format}"
              result[:success] = true
            end
          rescue => e
            result = rescue_return(e)
          end
          result
        end
      end
    end
  end
end
