class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    conversations = Conversation.where(recipient_id: current_user.id).or(Conversation.where(sender_id: current_user.id))
    conversations.each do |conversation|
      stream_from "chat_room_channel: #{conversation.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
