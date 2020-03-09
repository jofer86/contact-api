require 'rails_helper'

describe ContactsController do
    describe '#index' do
        subject { get :index }
        it 'should return a successs response' do
            subject
            expect(response).to have_http_status(:ok)
        end

        it 'should return proper json' do
            create_list :contact, 2
            subject       
            Contact.recent.each_with_index do |contact, i|
                expect(json_data[i]['attributes']).to eq({
                    "email" => contact.email,
                    "first-name" => contact.first_name,
                    "last-name" => contact.last_name,          
                    "phone-number" => contact.phone_number
                })
            end
        end
        it 'should return contacts in the proper order' do
            old_contact = create :contact
            new_contact = create :contact
            subject
            expect(json_data.first['id']).to eq(new_contact.id.to_s)
            expect(json_data.last['id']).to eq(old_contact.id.to_s)
        end
    end
end

