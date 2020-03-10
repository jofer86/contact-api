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
        it 'should return paginated results' do
            create_list :contact, 3
            get :index, params: { page: 2, per_page: 1 }
            expect(json_data.length).to eq 1
            expect(json_data.first['id']).to eq(Contact.recent.second.id.to_s)
        end
    end
    describe '#create' do
        context 'invalid parameters are being provided' do
            let(:invalid_attributes) do
                {
                    data: {
                        attributes: {
                            frist_name: '',
                            last_name: '',
                            email: '',
                            phone_number: '',
                        }
                    }
                }
            end
            subject { post :create, params: invalid_attributes }
            it 'should return status code 422' do
                subject                
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it 'should return an error to have proper json format' do
                subject        
                expect(json['errors']).to include(
                   {"source"=>{"pointer"=>"/data/attributes/first-name"},
                   "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/first-name"},
                    "detail"=>"is too short (minimum is 3 characters)"},
                   {"source"=>{"pointer"=>"/data/attributes/last-name"},
                    "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/last-name"},
                    "detail"=>"is too short (minimum is 3 characters)"},
                   {"source"=>{"pointer"=>"/data/attributes/email"}, "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/email"},
                    "detail"=>"invalid email format"},
                   {"source"=>{"pointer"=>"/data/attributes/phone-number"},
                    "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/phone-number"},
                    "detail"=>"input numbers only please"},
                   {"source"=>{"pointer"=>"/data/attributes/phone-number"},
                    "detail"=>"is too short (minimum is 11 characters)"}
            )
            end
        end
        let(:valid_attributes) do
            {
                'data' => {
                    'attributes' => {
                        'frist_name' => 'jorge',
                        'last_name' => 'rincon',
                        'email' => 'jorge@example.com',
                        'phone_number' => 529612255035,
                    }
                }
            }
        end
        subject { post :create, params: valid_attributes }

        it 'should return a 201 status code' do
            subject
            expect(response).to have_http_status(:created)
        end
        it 'should return a proper json body' do
            subject
            expect(json_data).to include(valid_attributes)
        end

        it 'should create the article' do
            expect{ subject }.to change{ Contact.count }.by(1)
        end
    end
end

