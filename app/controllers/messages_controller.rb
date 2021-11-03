class MessagesController < ApplicationController
  def create
    @conversation = Conversation.includes(:recipient).find(params[:conversation_id])
    @message = @conversation.messages.create(message_params)
    ChatRoomJob.perform_later(@message, current_user) 

    respond_to do |format|
      format.js
    end
  end

  def upload_attachment
    file_params = { attachment: attachment_params[:attachment].presence }
    @attachment = Attachment.new file_params
    @attachment.save
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :body, attachment_ids: [])
  end

  def attachment_params
    params.require(:message).permit(:attachment)
  end
end
