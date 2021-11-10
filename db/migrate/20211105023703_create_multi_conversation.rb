class CreateMultiConversation < ActiveRecord::Migration[6.1]
  def change
    create_table :multi_conversations do |t|
      t.integer :sender_id
      t.string :name

      t.timestamps
    end
    add_index :multi_conversations, :sender_id
  end
end
