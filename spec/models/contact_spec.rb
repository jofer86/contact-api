# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '#validations' do
    it 'should expect that the factory is a valid one' do
      expect((build :contact)).to be_valid
    end

    it 'should validate the presence of the first_name property' do
      contact = build :contact, first_name: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:first_name]).to include("can't be blank")
    end

    it 'should validate the presence of the last_name property' do
      contact = build :contact, last_name: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:last_name]).to include("can't be blank")
    end

    it 'should validate the presence of the email property' do
      contact = build :contact, email: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:email]).to include("can't be blank")
    end

    it 'should validate the uniqueness of the email property' do
      valid_contact = create :contact
      invalid_contact = build :contact, email: valid_contact.email
      expect(valid_contact).to be_valid
      expect(invalid_contact).not_to be_valid
      expect(invalid_contact.errors.messages[:email]).to include('has already been taken')
    end

    it 'should validate proper email format for the email property' do
      valid_contact = create :contact
      invalid_contact = build :contact, email: 'notvalidgmail.com'
      expect(valid_contact).to be_valid
      expect(invalid_contact).not_to be_valid
      expect(invalid_contact.errors.messages[:email]).to include('is invalid')
    end

    it 'should validate the presence of the phone_number property' do
      contact = build :contact, phone_number: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:phone_number]).to include("can't be blank")
    end
  end
end
