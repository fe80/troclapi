# frozen_string_literal: true

#
# This module is a helper for trocla format function
#
module FormatsHelpers
  #
  # @api private
  #
  def trocla_formats(key)
    logger.info "#{session[:user]} GET formats list for #{key}"
    result = { available: trocla.available_format(key), success: true }
    result[:available].nil? ? error_render('Key not found') : result
  rescue StandardError => e
    rescue_return(e.message)
  end

  #
  # @api private
  #
  def formats?(format, key: nil)
    return Trocla::Formats.available?(format) if key.nil?

    formats = trocla_formats(key)
    return false unless formats[:success]

    formats[:available].include?(format)
  end

  # Helper for format endpoints
  #
  # @param [String] format Trocla format
  # @param [String] key Trocla key
  def format_available(format, key: nil)
    available = formats?(format, key: key)
    { success: available, available: available }
  end
end
