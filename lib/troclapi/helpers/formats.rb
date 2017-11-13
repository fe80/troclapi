module Sinatra
  module Troclapi
    module Formats
      module Helpers
        def trocla_formats(trocla_key)
          result = {}
          result = check_empty({'trocla key' => trocla_key})
          return result unless result.empty?
          begin
            logger.info "#{session[:user]} GET formats list for #{trocla_key}"
            result[:available] = trocla.available_format(trocla_key)
            if result[:available].nil?
              return error_render('Key not found')
            else
              result[:success] = true
            end
          rescue => e
            result = rescue_return(e)
          end
          logger.debug result.to_s
          result
        end
        def trocla_formats?(trocla_key, format)
          trocla_formats(trocla_key)[:available].include?(format)
        end
      end
    end
  end
end
