class ChatGroupChannel < ApplicationCable::Channel
  def subscribed
    conversations = MultiConversation.where(sender_id: current_user.id)
                      .or(MultiConversation.where(group_conversations: {recipient_id: current_user.id}))
                      .left_joins(:group_conversations).distinct
    conversations.each do |conversation|
      stream_from "chat_group_channel: #{conversation.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
