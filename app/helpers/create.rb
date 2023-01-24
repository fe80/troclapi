# frozen_string_literal: true

#
# This module is a helper for trocla create function
#
module CreateHelpers
  #
  # @api private
  #
  def trocla_create(key, format, options)
    raise 'Trocla key is an empty value' if key.empty?

    raise 'Format is an empty value' if format.empty?

    logger.info "#{session[:user]} CREATE #{key} #{format}"
    {
      value: trocla.password(key, format, options),
      success: true, format: format
    }
  rescue StandardError => e
    rescue_return(e)
  end

  # Helper for create endpoint
  #
  # @param key The trocla key
  # @param format Trocla format
  # @param options Hash with trocla options
  # @return [Hash]
  def create(key, format, options)
    if format?(format)
      trocla_create(key, format, options)
    else
      bad_format(key, format)
    end
  end
end
