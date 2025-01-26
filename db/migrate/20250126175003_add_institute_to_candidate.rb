class AddInstituteToCandidate < ActiveRecord::Migration[7.2]
  def up
    # Change the data type of the `experience` column from `string` to `integer`
    change_column :candidates, :experience, :integer, using: 'experience::integer'

    # Add the `institute` column
    add_column :candidates, :institute, :string
  end

  def down
    # Revert the changes
    change_column :candidates, :experience, :string
    remove_column :candidates, :institute
  end
end
