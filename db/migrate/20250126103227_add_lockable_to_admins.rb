class AddLockableToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :failed_attempts, :integer, default: 0, null: false
    add_column :admins, :locked_at, :datetime
    add_column :admins, :unlock_token, :string

    add_index :admins, :unlock_token, unique: true
  end
end
