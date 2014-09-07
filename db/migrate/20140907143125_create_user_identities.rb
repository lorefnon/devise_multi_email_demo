class CreateUserIdentities < ActiveRecord::Migration
  def change
    create_table :user_identities do |t|
      t.integer :user_id, null: false
      t.integer :email_id, null: false
      t.string :uid, null: false
      t.string :provider, null: false

      t.timestamps null: false
    end

    add_index :user_identities, :user_id
    add_index :user_identities, :email_id
  end
end
