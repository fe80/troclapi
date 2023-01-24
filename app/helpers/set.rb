# frozen_string_literal: true

#
# This module is a helper for trocla set function
#
module SetHelpers
  #
  # @api private
  #
  def trocla_set(key, format, value, options)
    raise 'Trocla key is an empty value' if key.empty?

    raise 'Format is an empty value' if format.empty?

    raise 'Value is an empty value' if value.empty?

    logger.info "#{session[:user]} SET #{key} #{format}"
    {
      old_value: trocla.get_password(key, format), format: format,
      value: set_value(key, value, format, options), success: true
    }
  rescue StandardError => e
    rescue_return(e)
  end

  #
  # @api private
  #
  def set_value(key, value, format, options)
    convert = trocla.formats(format).format(value, options)
    trocla.set_password(key, format, convert)
  end

  # Helper for set endpoint
  #
  # @param key The trocla key
  # @param format Trocla format
  # @param options Hash with trocla options
  # @return [Hash]
  def set(key, format, value, options)
    if format?(format)
      trocla_set(key, format, value, options)
    else
      bad_format(key, format)
    end
  end
end
