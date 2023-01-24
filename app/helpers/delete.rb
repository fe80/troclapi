# frozen_string_literal: true

#
# This module is a helper for trocla delete function
#
module DeleteHelpers
  #
  # @api private
  #
  def trocla_delete(key, format)
    raise 'Trocla key is an empty value' if key.empty?

    raise 'Format is an empty value' if format.empty?

    logger.info "#{session[:user]} DELETE #{key} #{format}"
    {
      value: trocla.delete_password(key, format),
      success: true, format: format
    }
  rescue StandardError => e
    rescue_return(e)
  end

  # Helper for delete endpoint
  #
  # @param key The trocla key
  # @param format Trocla format
  # @return [Hash]
  def delete(key, format)
    if format?(format)
      trocla_delete(key, format)
    else
      bad_format(key, format)
    end
  end
end
