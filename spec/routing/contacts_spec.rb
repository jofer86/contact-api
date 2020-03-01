require 'rails_helper'

describe 'contacts routes' do
  it 'should provide a route for contacts index' do
    expect((get '/contacts')).to route_to('contacts#index')
  end
end