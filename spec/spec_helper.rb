# frozen_string_literal: true

troclarc = format(
  '%s/spec/datas/troclarc.yml',
  File.expand_path(File.dirname(File.dirname(__FILE__)))
)
puts troclarc
ENV['TROCLARC_FILE'] = troclarc
ENV['APP_ENV'] = 'test'

require 'json'
require 'sinatra/base'
require 'rack/test'
require 'test/unit'
require 'simplecov'
require 'simplecov-cobertura'

File.delete('/tmp/trocla.yaml') if File.exist?('/tmp/trocla.yaml') # Ensure fake store is remove

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
SimpleCov.start

Dir.glob('./app/controllers/*.rb').sort.each { |file| require file }
