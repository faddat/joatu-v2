class Message < DomainModel
  attribute :conversation, DomainModel.attr_type(:Conversation)
  attribute :sender, DomainModel.attr_type(:User)
  attribute :recipients, DomainCollection[:User]

  attribute :subject
  attribute :body

  attribute :created_at, nil, writer: :private
  attribute :updated_at, nil, writer: :private

  delegate :is_unread?, to: :model

  def persist!
    raise "Cannot persist a destroyed object!" if destroyed?

    recipient_models = recipients.map(&:model)
    receipt = sender.model.send_message(recipient_models, body, subject)
    self.model = receipt.message
    populate_from_model!
    self
  end
end
