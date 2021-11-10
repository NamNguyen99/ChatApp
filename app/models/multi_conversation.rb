class MultiConversation < ApplicationRecord
  has_many :messages, as: :target, dependent: :destroy
  has_many :group_conversations, foreign_key: "conversation_id", class_name: "GroupConversation"
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'

  accepts_nested_attributes_for :group_conversations, allow_destroy: true

  scope :between, -> (sender_id, recipient_id) do
    where(sender_id: sender_id, recipient_id: recipient_id).or(
      where(sender_id: recipient_id, recipient_id: sender_id)
    )
  end

  def self.get(sender_id, recipient_id)
    conversation = between(sender_id, recipient_id).first
    return conversation if conversation.present?

    create(sender_id: sender_id, recipient_id: recipient_id)
  end

  def opposed_user(user)
    user == recipient ? sender : recipient
  end

  def get_member_ids
    member_ids = []
    member_ids << self.sender_id
    member_ids.concat(self.group_conversations.pluck(:recipient_id))
    member_ids.compact.uniq
  end
end
