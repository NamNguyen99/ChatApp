class ChatGroupJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(message, user)
    file_url = message.attachments.map do |a|
      url_for(a.attachment)
    end
    file_name = message.attachments.map do |a|
      a.attachment.blob.filename
    end
    ActionCable.server.broadcast "chat_group_channel: #{message.target_id}", message: message, user: user, file: file_url, filename: file_name
  end
end
