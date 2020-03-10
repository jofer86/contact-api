# frozen_string_literal: true
class Contact < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :firstname, presence: true, length: { minimum: 3, maximum: 25 }
  validates :lastname, presence: true, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: EMAIL_REGEX, message: 'invalid email format'
  validates :phonenumber,
            presence: true,
            numericality: { message: 'input numbers only please' },
            length: { minimum: 11, maximum: 13 }
  scope :recent, -> { order(created_at: :desc) }
end
