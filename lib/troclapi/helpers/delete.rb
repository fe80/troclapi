module Sinatra
  module Troclapi
    module Delete
      module Helpers
        def trocla_delete(trocla_key, format)
          result = {}
          result = check_empty({'trocla key' => trocla_key, 'format' => format})
          return result unless result.empty?
          result[:format] = format
          begin
            trocla = Trocla.new
            logger.info "#{session[:user]} DELETE #{trocla_key} #{format}"
            result[:value] = trocla.delete_password(
              trocla_key,
              format
            )
            if result[:value].nil?
              logger.debug "Delete value for key #{trocla_key} on format #{format} not found"
              error(200, 'Key not found on this format')
            else
              logger.debug "Delete value for key #{trocla_key} on format #{format}"
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
