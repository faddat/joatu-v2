class ConversationRepo < BaseRepo
  class << self
    def reply_to_all(conversation, from_user, message_body)
      query ReplyToConversation.new(conversation, from_user, message_body)
    end

    def trash_for(user, conversation)
      query DeleteConversationForUser.new(conversation, user)
    end

    def untrash_for(user, conversation)
      query UndeleteConversationForUser.new(conversation, user)
    end

    def inbox_for_user(user, page = 1)
      query InboxConversationsForUser.new(user, page)
    end

    def sentbox_for_user(user, page = 1)
      query SentboxConversationsForUser.new(user, page)
    end

    def trash_for_user(user, page = 1)
      query TrashConversationsForUser.new(user, page)
    end
  end

  ReplyToConversation = Struct.new(:conversation, :from_user, :message_body)
  DeleteConversationForUser = Struct.new(:conversation, :user)
  UndeleteConversationForUser = Struct.new(:conversation, :user)
  InboxConversationsForUser = Struct.new(:user, :page)
  SentboxConversationsForUser = Struct.new(:user, :page)
  TrashConversationsForUser = Struct.new(:user, :page)
end
