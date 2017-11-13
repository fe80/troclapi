module Sinatra
  module Troclapi
    module Create
      module Helpers
        def trocla_create(trocla_key, format, options)
          result = {}
          result = check_empty({'trocla key' => trocla_key, 'format' => format})
          return result unless result.empty?
          result[:format] = format
          begin
            logger.info "#{session[:user]} CREATE #{trocla_key} #{format}"
            result[:value] = trocla.password(
              trocla_key,
              format,
              options
            )
            logger.debug "Create key #{trocla_key} on format #{format}"
            result[:success] = true
          rescue => e
            result = rescue_return(e)
          end
          result
        end
      end
    end
  end
end
