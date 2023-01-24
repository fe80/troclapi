# frozen_string_literal: true

#
# This modules contain global Troclapi helper
#
module TroclapiHelpers
  #
  # @api private
  #
  def trocla
    @trocla ||= Trocla.new(ENV['TROCLARC_FILE'])
  end

  #
  # @api private
  #
  def format?(format)
    if format.nil?
      logger.error 'Missing format'
      false
    elsif !Trocla::Formats.available?(format)
      logger.error format('The format %s is not available', format)
      false
    else
      true
    end
  end

  #
  # @api private
  #
  def playload
    @playload ||= request_payload
  end

  #
  # @api private
  #
  def request_payload
    request.body.rewind
    body = (request.body.read || {})
    content_type :json
    body.empty? ? {} : JSON.parse(body)
  rescue StandardError => e
    logger.error e.to_s
    error(400, 'Couldn\'t read data')
  end

  #
  # @api private
  #
  def check_empty(hash)
    h = {}
    hash.each do |k, v|
      h = error_render("Missing #{k}") if v.empty?
    end
    h
  end

  #
  # @api private
  #
  def rescue_return(error)
    logger.error error.message
    logger.debug error.backtrace.join("\n")
    begin
      @trocla&.close
    rescue StandardError => e
      logger.error e.message
      logger.debug 'Close connexion fail'
    end
    @trocla = nil
    error(500, error.message)
  end

  #
  # @api private
  #
  def keys?(keys)
    error(400, 'Missing keys') if keys.nil? || keys.empty?
  end

  #
  # @api private
  #
  def bad_format(trocla_key, format)
    logger.debug "Bad format #{format} for key #{trocla_key}"
    error_render('Bad format')
  end

  #
  # @api private
  #
  def error(code, message)
    halt code, error_render(message).to_json
  end

  #
  # @api private
  #
  def error_render(message)
    { success: false, error: message }
  end
end
