# frozen_string_literal: true

#
# This module is a helper for trocla search function
#
module SearchHelpers
  #
  # @api private
  #
  def trocla_search(key)
    raise 'Search key is an empty value' if key.empty?

    logger.info "#{session[:user]} SEARCH #{key}"
    {
      keys: trocla.search_key(key),
      success: true
    }
  rescue StandardError => e
    rescue_return(e)
  end

  # Helper for search endpoints
  #
  # @return [Hash]
  def search(key)
    trocla_search(key)
  end
end
