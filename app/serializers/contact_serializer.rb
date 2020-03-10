class ContactSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :email, :phonenumber
end
