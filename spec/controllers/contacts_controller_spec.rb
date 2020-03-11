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
                    "firstname" => contact.firstname,
                    "lastname" => contact.lastname,          
                    "phonenumber" => contact.phonenumber
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
                            fristname: '',
                            lastname: '',
                            email: '',
                            phonenumber: '',
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
                   {"source"=>{"pointer"=>"/data/attributes/firstname"},
                   "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/firstname"},
                    "detail"=>"is too short (minimum is 3 characters)"},
                   {"source"=>{"pointer"=>"/data/attributes/lastname"},
                    "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/lastname"},
                    "detail"=>"is too short (minimum is 3 characters)"},
                   {"source"=>{"pointer"=>"/data/attributes/email"}, "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/email"},
                    "detail"=>"invalid email format"},
                   {"source"=>{"pointer"=>"/data/attributes/phonenumber"},
                    "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/phonenumber"},
                    "detail"=>"input numbers only please"},
                   {"source"=>{"pointer"=>"/data/attributes/phonenumber"},
                    "detail"=>"is too short (minimum is 11 characters)"}
            )
            end
        end
        let(:valid_attributes) do
            {
                'data' => {
                    'attributes' => {
                        'firstname' => 'jorge',
                        'lastname' => 'rincon',
                        'email' => 'jorge@example.com',
                        'phonenumber' => 529612255035,
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
            expect(json_data['attributes']).to include(valid_attributes['data']['attributes'])
        end

        it 'should create the article' do
            expect{ subject }.to change{ Contact.count }.by(1)
        end
    end
    describe '#update' do
        let(:contact){ create :contact }
        context 'invalid parameters are being provided' do
            let(:invalid_attributes) do
                {
                    data: {
                        attributes: {
                            fristname: '',
                            lastname: '',
                            email: '',
                            phonenumber: '',
                        }
                    }
                }
            end
            subject do
                patch :update, params: invalid_attributes.merge(id: contact.id)
            end
            it 'should return status code 422' do
                subject                
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it 'should return an error to have proper json format' do
                subject
                expect(json['errors']).to include(
                    {"source"=>{"pointer"=>"/data/attributes/lastname"},
                    "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/lastname"},
                    "detail"=>"is too short (minimum is 3 characters)"},
                   {"source"=>{"pointer"=>"/data/attributes/email"}, "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/email"},
                    "detail"=>"invalid email format"},
                   {"source"=>{"pointer"=>"/data/attributes/phonenumber"},
                    "detail"=>"can't be blank"},
                   {"source"=>{"pointer"=>"/data/attributes/phonenumber"},
                    "detail"=>"input numbers only please"},
                   {"source"=>{"pointer"=>"/data/attributes/phonenumber"},
                    "detail"=>"is too short (minimum is 11 characters)"}
            )
            end
        end
        let(:valid_attributes) do
            {
                'data' => {
                    'attributes' => {
                        'firstname' => contact.firstname,
                        'lastname' => contact.lastname,
                        'email' => contact.email,
                        'phonenumber' => contact.phonenumber,
                    }
                }
            }
        end
        subject do
            patch :update, params: valid_attributes.merge(id: contact.id)
        end

        it 'should return a 201 status code' do
            subject
            expect(response).to have_http_status(:created)
        end
        it 'should return a proper json body' do
            subject
            expect(json_data['attributes']).to include(valid_attributes['data']['attributes'])
        end

        it 'should update the article' do
            subject
            expect(contact.reload.firstname).to eq(
                valid_attributes['data']['attributes']['firstname']
            )
        end
    end
    describe '#destroy' do
        let (:contact) { create :contact }
        subject { delete :destroy, params: { id: contact.id } }

        it 'should return a 204 status code' do
            subject
            expect(response).to have_http_status(:no_content)
        end
        it 'should return an empty json body' do
            subject
            expect(response.body).to be_blank
        end

        it 'should obliterate the article' do
            expect{ subject }.to change{ Contact.count }.by(-1)
        end
    end
end

