class CreateInvitations < ActiveRecord::Migration[7.2]
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.string :status, default: 'pending', null: false
      t.timestamps
    end

    add_index :invitations, :email
    add_index :invitations, :token, unique: true
  end
end
