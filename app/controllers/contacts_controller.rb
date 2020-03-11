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

  def update
    contact = Contact.find(params[:id])
    contact.update_attributes!(contact_params)
    render json: contact, status: 201
  rescue
    render json: contact, adapter: :json_api,
    serializer: ActiveModel::Serializer::ErrorSerializer,
    status: :unprocessable_entity
  
  end

  private

  def contact_params
    params.require(:data).require(:attributes).
      permit(:firstname, :lastname, :email, :phonenumber) ||
    ActionController::Parameters.new
  end

end