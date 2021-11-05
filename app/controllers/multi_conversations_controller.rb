class MultiConversationsController < ApplicationController
  def create
    current_multi_conversation = MultiConversation.find_by(id: params[:id])
    @multi_conversation = current_multi_conversation || MultiConversation.create(sender: current_user)
    add_to_conversations unless conversated?

    @multi_conversation.group_conversations.create(recipient_id: params[:recipient])
    
    respond_to do |format|
      format.js
    end
  end

  def close
    @multi_conversation = MultiConversation.find(params[:id])

    session[:multi_conversations].delete(@multi_conversation.id)

    respond_to do |format|
      format.js
    end
  end

  def add_member
    @multi_conversation = Conversation.find(params[:id])
    @users = User.all.where.not(id: @conversation.get_member_ids)
    @multi_conversation.group_conversations.create(recipient_id: params[:recipient])
  end

  private

  def multi_conversation_params
    params.require(:multi_conversation).permit(group_conversations_attributes: [:id, :recipient_id, :_destroy])
  end

  def add_to_multi_conversations
    
    session[:multi_conversations] ||= []
    session[:multi_conversations] << @multi_conversation.id
  end

  def conversated?
    session[:multi_conversations].include?(@multi_conversation.id)
  end
end
