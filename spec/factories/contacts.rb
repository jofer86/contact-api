# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    sequence(:first_name) {|n| "My first name #{n}"}
    sequence(:last_name) {|n| "my last name #{n}"}
    sequence(:email) {|n| "myemail#{n}@example.com"}
    sequence(:phone_number) {|n| ("#{n}29612255035".to_i) }

  end
end
