class EventRegistrationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :user, :agreed_to_policy, :paying_cash, :paid_with_card

  def user
    ActiveModelSerializers::SerializableResource.new object.user
  end

  def paying_cash
    object.paying_cash?
  end

  def paid_with_card
    object.paid_with_card?
  end
end
