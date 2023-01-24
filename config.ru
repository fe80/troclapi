# frozen_string_literal: true

require 'sinatra/base'
Dir.glob('./app/controllers/*.rb').sort.each { |file| require file }

Troclapi.run!
