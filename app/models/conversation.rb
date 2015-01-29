class Conversation < DomainModel
  attribute :subject
  attribute :created_at
  attribute :updated_at

  attribute :last_sender, DomainModel.attr_type(:User)
  attribute :last_message, DomainModel.attr_type(:Message)
  attribute :recipients, DomainCollection[:User]

  def read_messages_for_user_and_box!(user_model, box)
    box_type = (box == 'trash') ? 'trash' : 'not_trash'
    receipts = user_model.mailbox.receipts_for(self.model).send(box_type)
    receipts.mark_as_read
    receipts.map(&:message).map {|m| Message.new(m)}
  end

  def reply_to_all(user_model, body)
    last_receipt = user_model.mailbox.receipts_for(self.model).last
    user_model.reply_to_all(last_receipt, body)
  end

  # Takes one parameter, the messageable that is destrying the conversation
  # (it show as trashed only for them)
  def trash_for(user)
    repo.trash_for(user, self)
  end

  def untrash_for(user)
    repo.untrash_for(user, self)
  end

  class Queries < SimpleDelegator
    def initialize(model_class)
      @model = model_class
      super @model
    end

    def user_conversations(user, box)
      user.mailbox.send(box)
    end
  end
end
