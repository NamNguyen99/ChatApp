class MultiConversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :group_conversations
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'

  validates :sender_id, uniqueness: { scope: :recipient_id }

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
    menber_ids << self.recipient_id
    menber_ids.concat(self.group_conversations.pluck(:recipient_id))
    menber_ids.compact.uniq
  end
end
