module Sinatra
  module Troclapi
    module Set
      module Helpers
        def trocla_set(trocla_key, format, value)
          result = {}
          result = check_empty({'trocla key' => trocla_key, 'format' => format, :value => value})
          return result unless result.empty?
          result[:format] = format
          begin
            logger.info "#{session[:user]} SET #{trocla_key} #{format}"
            result[:value] = trocla.set_password(
              trocla_key,
              format,
              value
            )
            result[:success] = true
            logger.debug "Set value for key #{trocla_key} on format #{format}"
          rescue => e
            result = rescue_return(e)
          end
          result
        end
      end
    end
  end
end
