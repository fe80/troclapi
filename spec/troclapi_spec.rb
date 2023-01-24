# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe 'Troclapi' do
  include Rack::Test::Methods

  let(:headers) { { 'HTTP_X_TOKEN' => 'toto' } }

  def app
    Troclapi.new
  end

  it 'version' do
    get '/version'
    expect(last_response.status).to eq 200
    expect(last_response.body).to match(/api_version/)
  end

  context 'create endpoint' do
    it 'mykey0 plain' do
      post '/v1/key/mykey0/plain', { length: 20 }.to_json, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['value'].length).to eq 20
    end

    it 'mykey0 mysql' do
      post '/v1/key/mykey0/mysql', nil, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
    end
  end

  context 'delete endpoint' do
    it 'mykey0 mysql' do
      delete '/v1/key/mykey0/mysql', nil, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
    end
  end

  context 'format endpoint' do
    it 'list all' do
      get '/v1/formats', nil, headers

      body = JSON.parse(last_response.body)
      expect(body['success']).to be true
      expect(body['available']).to be_an_instance_of(Array)
    end

    it 'check plain' do
      get '/v1/formats/plain', nil, headers

      body = JSON.parse(last_response.body)
      expect(body['success']).to be true
      expect(body['available']).to be true
    end

    it 'check mykey0 plain' do
      get '/v1/formats/mykey0/plain', nil, headers

      body = JSON.parse(last_response.body)
      expect(body['success']).to be true
      expect(body['available']).to be true
    end

    it 'check mykey0 mysql' do
      get '/v1/formats/mykey0/mysql', nil, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 404
      expect(body['success']).to be false
      expect(body['available']).to be false
    end
  end

  context 'get endpoint' do
    it 'mykey0 plain' do
      get '/v1/key/mykey0/plain', nil, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['value'].length).to eq 20
    end

    it 'mykey0 mysql' do
      get '/v1/key/mykey0/mysql', nil, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 404
      expect(body['success']).to be false
    end
  end

  context 'reset endpoint' do
    it 'mykey0 plain' do
      patch '/v1/key/mykey0/plain', { length: 20 }.to_json, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['value'].length).to eq 20
    end

    it 'mykey0 mysql' do
      patch '/v1/key/mykey0/mysql', nil, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
    end
  end

  context 'search endpoint' do
    it 'm*key0 regexp' do
      get '/v1/search/m*key0', { length: 20 }.to_json, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['keys']).to eq ['mykey0']
    end
  end

  context 'set endpoint' do
    it 'mykey1 plain to bob' do
      put '/v1/key/mykey1/plain', { value: 'bob' }.to_json, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['value']).to eq 'bob'
    end

    it 'mykey1 plain to alice' do
      put '/v1/key/mykey1/plain', { value: 'alice' }.to_json, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['old_value']).to eq 'bob'
      expect(body['value']).to eq 'alice'
    end

    it 'mykey1 pgsql to alice' do
      put '/v1/key/mykey1/pgsql', { value: 'alice', username: 'alice' }.to_json, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['value']).to match(/^SCRAM-SHA-256/)
    end

    it 'mykey1 pgsql to alice with md5' do
      put '/v1/key/mykey1/pgsql', { value: 'alice', username: 'alice', encode: 'md5' }.to_json, headers

      body = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(body['success']).to be true
      expect(body['value']).to match(/^md5/)
    end
  end
end
# rubocop:enable Metrics/BlockLength
