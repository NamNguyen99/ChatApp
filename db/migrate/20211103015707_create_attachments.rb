class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.references :target, polymorphic: true

      t.timestamps
    end
  end
end
