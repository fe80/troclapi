module Sinatra
  module Troclapi
    module Reset
      module Helpers
        def trocla_reset(trocla_key, format, options)
          result = {}
          result = check_empty({'trocla key' => trocla_key, 'format' => format})
          return result unless result.empty?
          result[:format] = format
          begin
            trocla = Trocla.new
            logger.info "#{session[:user]} RESET #{trocla_key} #{format}"
            result[:value] = trocla.reset_password(
              trocla_key,
              format,
              options
            )
            result[:success] = true
            logger.debug "Reset value for key #{trocla_key} on format #{format}"
          rescue => e
            result = rescue_return(e)
          end
          result
        end
      end
    end
  end
end
