class ChatRoomJob < ApplicationJob
  queue_as :default

  def perform(message, user)
    ActionCable.server.broadcast "chat_room_channel: #{message.conversation_id}", message: message, user: user
  end
end
