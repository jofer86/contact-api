# frozen_string_literal: true
class Contact < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :first_name, presence: true, length: { minimum: 3, maximum: 25 }
  validates :last_name, presence: true, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: EMAIL_REGEX, message: 'invalid email format'
  validates :phone_number,
            presence: true,
            numericality: { message: 'input numbers only please' },
            length: { minimum: 11, maximum: 13 }
end
