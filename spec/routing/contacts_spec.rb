require 'rails_helper'

describe 'contacts routes' do
  it 'should provide a route for contacts index' do
    expect((get '/contacts')).to route_to('contacts#index')
  end

  it 'should provide a route for contacts show' do
    expect((get '/contacts/1')).to route_to('contacts#show', id: '1')
  end

  it 'should provide a route for contacts create' do
    expect(post 'contacts').to route_to('contacts#create')
  end
end