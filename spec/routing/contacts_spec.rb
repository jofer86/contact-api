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

  it 'should provide a route for contacts update' do
    expect(put '/contacts/1').to route_to('contacts#update', id: '1')
    expect(patch '/contacts/1').to route_to('contacts#update', id: '1')
  end
  it 'should provide a route for contacts destroy' do
    expect(delete '/contacts/1').to route_to('contacts#destroy', id: '1')
  end
end