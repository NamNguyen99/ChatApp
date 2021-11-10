class ChatGroupJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(message, user)
    file_url = message.attachments.map do |a|
      url_for(a.attachment)
    end
    ActionCable.server.broadcast "chat_group_channel: #{message.target_id}", message: message, user: user, file: file_url
  end
end
