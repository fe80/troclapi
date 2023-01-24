# frozen_string_literal: true

#
# This module is a helper for trocla create function
#
module GetHelpers
  #
  # @api private
  #
  def trocla_get(key, format, options)
    raise 'Trocla key is an empty value' if key.empty?

    raise 'Format is an empty value' if format.empty?

    logger.info "#{session[:user]} GET #{key} #{format}"

    {
      value: trocla.get_password(key, format, options),
      format: format, success: true
    }
  rescue StandardError => e
    rescue_return(e)
  end

  # Helper for get endpoints
  #
  # @param key The trocla key
  # @param format Trocla format
  # @param options Hash with trocla options
  # @return [Hash]
  def get(key, format, options)
    if format?(format)
      trocla_get(key, format, options)
    else
      bad_format(key, format)
    end
  end
end
