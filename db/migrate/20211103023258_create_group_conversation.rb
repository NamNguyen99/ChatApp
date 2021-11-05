class CreateGroupConversation < ActiveRecord::Migration[6.1]
  def change
    create_table :group_conversations do |t|
      t.integer :conversation_id
      t.integer :recipient_id
      
      t.timestamps
    end
    add_index :group_conversations, :recipient_id
    add_index :group_conversations, :conversation_id
    add_index :group_conversations, [:recipient_id, :conversation_id], unique: true
  end
end
