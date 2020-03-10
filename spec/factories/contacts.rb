# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    sequence(:firstname) {|n| "My first name #{n}"}
    sequence(:lastname) {|n| "my last name #{n}"}
    sequence(:email) {|n| "myemail#{n}@example.com"}
    sequence(:phonenumber) {|n| "#{n}29612255035" }

  end
end
