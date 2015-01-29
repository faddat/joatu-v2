class ConversationsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_box

  # We look up conversations by user, no need to scope it too.
  skip_after_filter :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @conversations = ConversationRepo.send("#{@box}_for_user", authenticated_user, params[:page])
    respond_with(@conversations)
  end

  def show
    @reply = MessageForm.new(Message.new)
    @conversation = ConversationRepo.find(params[:id])
    @messages = MessageRepo.read_messages(@conversation, authenticated_user, @box)
    authorize @conversation
    respond_with(@conversation)
  end

  def update
    @conversation = ConversationRepo.find(params[:id])
    authorize @conversation
    if params[:untrash].present?
      @conversation.untrash_for(authenticated_user)
    end
    
    if params[:reply_all].present?
      @form = MessageForm.new(Message.new)
      if @form.validate(params[:message])
        @form.save do |message_data|
          @receipt = ConversationRepo.reply_to_all(@conversation, authenticated_user, message_data[:body])
        end
        @messages = MessageRepo.read_messages(@conversation, authenticated_user, @box)
        redirect_to action: :show
      else
        @reply = @form
        render :show
      end
    end

  end

  def destroy
    @conversation = ConversationRepo.find(params[:id])
    authorize @conversation
    @conversation.trash_for(authenticated_user)

    if params[:location].present? and params[:location] == 'conversation'
      redirect_to conversations_path(:box => :trash)
    else
      redirect_to conversations_path(:box => @box,:page => params[:page])
    end
  end

  private

  def get_box
    if params[:box].blank? or !["inbox","sentbox","trash"].include?params[:box]
      params[:box] = 'inbox'
    end

    @box = params[:box]
  end
end
