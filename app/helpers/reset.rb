# frozen_string_literal: true

#
# This module is a helper for trocla reset function
#
module ResetHelpers
  #
  # @api private
  #
  def trocla_reset(key, format, options)
    raise 'Trocla key is an empty value' if key.empty?

    raise 'Format is an empty value' if format.empty?

    logger.info "#{session[:user]} RESET #{key} #{format}"
    {
      old_value: trocla.get_password(key, format, options),
      value: trocla.reset_password(key, format, options),
      success: true, format: format
    }
  rescue StandardError => e
    rescue_return(e)
  end

  # Helper for reset endpoints
  #
  # @param key The trocla key
  # @param format Trocla format
  # @param options Hash with trocla options
  # @return [Hash]
  def reset(key, format, options)
    if format?(format)
      trocla_reset(key, format, options)
    else
      bad_format(key, format)
    end
  end
end
