require 'troclapi/v1/get'
require 'troclapi/v1/create'
require 'troclapi/v1/delete'
require 'troclapi/v1/format'
require 'troclapi/v1/reset'
require 'troclapi/v1/search'
require 'troclapi/v1/set'

class Troclapi < Sinatra::Base

  register Sinatra::Troclapi::V1::Get
  register Sinatra::Troclapi::V1::Create
  register Sinatra::Troclapi::V1::Delete
  register Sinatra::Troclapi::V1::Format
  register Sinatra::Troclapi::V1::Reset
  register Sinatra::Troclapi::V1::Search
  register Sinatra::Troclapi::V1::Set

end
