require 'rails_helper'

describe ContactsController do
    describe '#index' do
        subject { get :index }
        it 'should return a successs response' do
            subject
            expect(response).to have_http_status(:ok)
        end

        it 'should return proper json' do
            contacts = create_list :contact, 2 
            subject           
            contacts.each_with_index do |contact, i|
                expect(json_data[i]['attributes']).to eq({
                    "email" => contact.email,
                    "first-name" => contact.first_name,
                    "last-name" => contact.last_name,          
                    "phone-number" => contact.phone_number
                })
            end
        end
    end
end

