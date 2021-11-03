class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_many :attachment, as: :target

  # after_commit -> { ChatRoomJob.perform_later(self) }
end
