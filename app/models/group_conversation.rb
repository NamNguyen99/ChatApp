class GroupConversation < ApplicationRecord
  belongs_to :multi_conversation, foreign_key: :conversation_id, class_name: 'MultiConversation'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
end

