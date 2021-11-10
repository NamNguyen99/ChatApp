class MessagesController < ApplicationController
  def create
    if new_attachment_params[:attachment].present?
      @attachment = Attachment.new new_attachment_params
      @attachment.save
    end
    message = EmojiService.new(message_params[:body]).emojify
    if params.dig(:multi_conversation_id).present?
      @conversation = MultiConversation.includes(:group_conversations).find(params[:multi_conversation_id])
      @message = @conversation.messages.create(message_params.merge(body: message))
      @message.update(attachment_ids: [@attachment.id]) if @attachment.present?
      ChatGroupJob.perform_later(@message, current_user) 
    else
      @conversation = Conversation.includes(:recipient).find(params[:conversation_id])
      @message = @conversation.messages.create(message_params.merge(body: message))
      @message.update(attachment_ids: [@attachment.id]) if @attachment.present?
      ChatRoomJob.perform_later(@message, current_user) 
    end

    respond_to do |format|
      format.js
    end
  end

  def upload_attachment
    file_params = { attachment: attachment_params[:attachment].presence }
    @attachment = Attachment.new file_params
    @attachment.save
    
    respond_to do |format|
      format.js { 
        render :template => "messages/upload_attachment.js.erb", 
               :layout => false  
      }
    end
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :body, attachment_ids: [])
  end

  def attachment_params
    params.permit(:attachment)
  end

  def new_attachment_params
    params.require(:message).permit(:attachment)
  end
end
