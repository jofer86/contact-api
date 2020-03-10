# frozen_string_literal: true

require 'rails_helper'

VALID_MIN_STRING = 'a' * 3
VALID_MAX_STRING = 'a' * 25

INVALID_MIN_STRING = 'a' * 2
INVALID_MAX_STRING = 'a' * 26

RSpec.describe Contact, type: :model do
  describe '#validations' do
    it 'should expect that the factory is a valid one' do
      contact = build :contact
      pp contact
      expect(contact).to be_valid
    end

    it 'should validate the presence of the first_name property' do
      contact = build :contact, firstname: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:firstname]).to include("can't be blank")
    end

    it 'should validate apropriate length for firstname property' do
      valid_min_contact = build :contact, firstname: VALID_MIN_STRING
      valid_max_contact = build :contact, firstname: VALID_MAX_STRING
      invalid_min_contact = build :contact, firstname: INVALID_MIN_STRING
      invalid_max_contact = build :contact, firstname: INVALID_MAX_STRING
      expect(valid_min_contact).to be_valid
      expect(valid_max_contact).to be_valid
      expect(invalid_min_contact).to_not be_valid
      expect(invalid_max_contact).to_not be_valid
    end

    it 'should validate apropriate length for lastname property' do
      valid_min_contact = build :contact, lastname: VALID_MIN_STRING
      valid_max_contact = build :contact, lastname: VALID_MAX_STRING
      invalid_min_contact = build :contact, lastname: INVALID_MIN_STRING
      invalid_max_contact = build :contact, lastname: INVALID_MAX_STRING
      expect(valid_min_contact).to be_valid
      expect(valid_max_contact).to be_valid
      expect(invalid_min_contact).to_not be_valid
      expect(invalid_max_contact).to_not be_valid
    end

    it 'should validate the presence of the lastname property' do
      contact = build :contact, lastname: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:lastname]).to include("can't be blank")
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

    it 'should validate the presence of the phonenumber property' do
      contact = build :contact, phonenumber: ''
      expect(contact).not_to be_valid
      expect(contact.errors.messages[:phonenumber]).to include("can't be blank")
    end

    it 'should validate the numericality of the phonenumber property' do
      valid_contact = create :contact
      invalid_contact = build :contact, phonenumber: 'a9625574324'
      expect(valid_contact).to be_valid
      expect(invalid_contact).to_not be_valid
      expect(invalid_contact.errors.messages[:phonenumber]).to include('input numbers only please')
    end

    it 'should validate the length of the phonenumber property' do
      valid_contact = create :contact
      invalid_min_contact = build :contact, phonenumber: 1234567890
      invalid_max_contact = build :contact, phonenumber: 12345678901234
      expect(invalid_min_contact).not_to be_valid
      expect(invalid_min_contact.errors.messages[:phonenumber]).to include("is too short (minimum is 11 characters)")
      expect(invalid_max_contact).not_to be_valid
      expect(invalid_max_contact.errors.messages[:phonenumber]).to include("is too long (maximum is 13 characters)")
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
