class HomeController < ApplicationController
  def index
    session[:conversations] ||= []
    session[:multi_conversations] ||= []

    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages)
                                 .find(session[:conversations])

    @multi_conversations = MultiConversation.where(sender: current_user)
      .or(MultiConversation.where(group_conversations: {recipient_id: current_user.id}))
      .left_joins(:group_conversations).distinct
  end
end
