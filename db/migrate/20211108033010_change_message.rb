class ChangeMessage < ActiveRecord::Migration[6.1]
  def change
    change_table(:messages) do |t|
      t.references :target, polymorphic: true
    end
  end
end
