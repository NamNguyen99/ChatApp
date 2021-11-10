class ChangeMessageConstraint < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messages, :conversation_id, true
  end
end
