class ContactsController < ApplicationController
  def index
    contacts = Contact.recent.page(params[:page]).per(params[:per_page])
    render json: contacts
  end

  def show

  end

  def create
    contact = Contact.new(contact_params)
    if contact.valid?
      contact.save
      render json: contact, status: 201
    else
      render json: contact, adapter: :json_api,
        serializer: ActiveModel::Serializer::ErrorSerializer,
        status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:data).require(:attributes).
      permit(:first_name, :last_name, :email, :phone_number) ||
    ActionController::Parameters.new
  end

end