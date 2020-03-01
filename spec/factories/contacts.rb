# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    first_name { 'MyString' }
    last_name { 'MyString' }
    email { 'MyString@example.com' }
    phone_number { 'MyString' }
  end
end
