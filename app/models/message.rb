class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation, optional: true
  belongs_to :target, polymorphic: true, optional: true

  has_many :attachments, as: :target

  # after_commit -> { ChatRoomJob.perform_later(self) }
end
