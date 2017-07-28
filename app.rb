#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'sinatra/multi_route'
require 'trocla'
require 'yaml'
require 'json'
require 'logger'
require 'ipaddr'

def check_format(format_name)
  if format_name.nil?
    $logger.error 'Missing format, exiting...'
    return false
  elsif !Trocla::Formats.available?(format_name)
    $logger.error "Error: The format #{format_name} is not available"
    return false
  else
    return true
  end
end

# Main programe

# Intialize trocla class
$trocla = Trocla.new

if $trocla.config['api'].nil? || !($trocla.config['api']['enable']||=false)
  STDERR.puts "Error, api is not enable"
  exit 1
end

log_path = ($trocla.config['api']['log']||='troclapi.log')

if not File.writable?(File.dirname(log_path)) && File.directory?(File.dirname(log_path))
  STDERR.puts "Error, log directory path doesn't exist or not writable"
  exit 1
end

$logger = Logger.new(log_path)
$logger.level = ($trocla.config['api']['log_level']||='WARN').upcase
$logger.datetime_format = '%Y-%m-%d %H:%M:%S'

# Set sinatra config
($trocla.config['api']['setting']||={}).each do |k,v|
  set k, v
end

# Before all
before do
  content_type :json

  ($trocla.config['api']['allow_ip'] ||= ['0.0.0.0/0']).each do |i|
    ip_allow = IPAddr.new(i)
    client_ip = IPAddr.new request.ip
    pass if ip_allow.include?(client_ip)
  end

  content_type :text
  halt 403, '403 Forbiden'
end

actions = ($trocla.config['api']['actions'] || [ 'format', 'create', 'get', 'set', 'reset', 'delete', 'search' ])

# Include allow actions
actions.each do |action|
  require_relative "v1/#{action}.rb"
end

# Match default traffic for a 404 return
route :get, :post, :head, :options, :connect, :trace, :put, :patch, :delete, '/*' do
  # Define text content type
  $logger.error "Bad url #{request.path} from ip #{request.ip}"
  content_type :text
  halt 404, '404, bad url or request methods'
end
