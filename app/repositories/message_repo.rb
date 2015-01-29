class MessageRepo < BaseRepo
  class << self
    def read_messages(conversation, authenticated_user, box)
      query ReadAndRetrieveMessagesForConversationUserBox.new(conversation, authenticated_user, box)
    end
  end

  ReadAndRetrieveMessagesForConversationUserBox= Struct.new(:conversation, :user, :box)
end
