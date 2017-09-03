module Sinatra
  module Troclapi
    module Search
      module Helpers
        def trocla_search(trocla_key)
          result = {}
          result = check_empty({'trocla key' => trocla_key})
          return result unless result.empty?
          begin
            trocla = Trocla.new
            logger.info "#{session[:user]} SEARCH #{trocla_key}"
            search = trocla.search_key(trocla_key)
            result[trocla_key] =  if search.empty?
                                    nil
                                  else
                                    search
                                  end
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
