class ContactsController < ApplicationController
  def index
    contacts = Contact.recent
    render json: contacts
  end

  def show

  end
end