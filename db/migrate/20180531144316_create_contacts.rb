class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :email, limit: 254, null: false
      t.string :normalized_email, limit: 254, null: false

      t.timestamps
    end
    add_index :contacts, :normalized_email, unique: true
  end
end
