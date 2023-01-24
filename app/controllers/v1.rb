# frozen_string_literal: true

#
# This class include all v1 endpoint
#
class Troclapi < Sinatra::Base
  before '/v1/*' do
    redirect(to('/login')) unless authorize?
  end

  actions = troclapi['actions'] || %w[formats create get set reset delete search]

  actions.each do |action|
    require "./app/controllers/v1/#{action}"
  end
end
