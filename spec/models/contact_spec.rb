# frozen_string_literal: true

require 'rails_helper'

VALID_MIN_STRING = 'a' * 3
VALID_MAX_STRING = 'a' * 25

INVALID_MIN_STRING = 'a' * 2
INVALID_MAX_STRING = 'a' * 26

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

    it 'should validate apropriate length for first_name property' do
      valid_min_contact = build :contact, first_name: VALID_MIN_STRING
      valid_max_contact = build :contact, first_name: VALID_MAX_STRING
      invalid_min_contact = build :contact, first_name: INVALID_MIN_STRING
      invalid_max_contact = build :contact, first_name: INVALID_MAX_STRING
      expect(valid_min_contact).to be_valid
      expect(valid_max_contact).to be_valid
      expect(invalid_min_contact).to_not be_valid
      expect(invalid_max_contact).to_not be_valid
    end

    it 'should validate apropriate length for last_name property' do
      valid_min_contact = build :contact, last_name: VALID_MIN_STRING
      valid_max_contact = build :contact, last_name: VALID_MAX_STRING
      invalid_min_contact = build :contact, last_name: INVALID_MIN_STRING
      invalid_max_contact = build :contact, last_name: INVALID_MAX_STRING
      expect(valid_min_contact).to be_valid
      expect(valid_max_contact).to be_valid
      expect(invalid_min_contact).to_not be_valid
      expect(invalid_max_contact).to_not be_valid
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
      expect(invalid_contact.errors.messages[:email]).to include('invalid email format')
    end

    it 'should validate the presence of the phone_number property' do
      contact = build :contact, phone_number: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:phone_number]).to include("can't be blank")
    end

    it 'should validate the numericality of the phone_number property' do
      valid_contact = create :contact
      invalid_contact = build :contact, phone_number: 'a9625574324'
      expect(valid_contact).to be_valid
      expect(invalid_contact).to_not be_valid
      expect(invalid_contact.errors.messages[:phone_number]).to include('input numbers only please')
    end

    it 'should validate the length of the phone_number property' do
      valid_contact = create :contact
      invalid_min_contact = build :contact, phone_number: 1234567890
      invalid_max_contact = build :contact, phone_number: 12345678901234
      expect(invalid_min_contact).not_to be_valid
      expect(invalid_min_contact.errors.messages[:phone_number]).to include("is too short (minimum is 11 characters)")
      expect(invalid_max_contact).not_to be_valid
      expect(invalid_max_contact.errors.messages[:phone_number]).to include("is too long (maximum is 13 characters)")
    end
    describe '.recent' do
      it 'should show the most recent contact first' do
        old_contact = create :contact
        new_contact = create :contact
        expect(described_class.recent).to eq(
          [ new_contact, old_contact ]
        )
        old_contact.update_column :created_at, Time.now
        expect(described_class.recent).to eq(
          [ old_contact, new_contact  ]
        )
      end
    end
  end
end
