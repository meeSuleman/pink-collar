class AddEmploymentDetailsToCandidates < ActiveRecord::Migration[7.2]
  def change
    add_column :candidates, :currently_employed, :boolean, default: false
    add_column :candidates, :current_salary, :string
    add_column :candidates, :current_employer, :string
    add_column :candidates, :function, :integer
    add_column :candidates, :address, :string, null: false, default: ""
    add_column :candidates, :city, :string
    add_column :candidates, :state, :string
    change_column :candidates, :education, :integer, using: 'education::integer'
  end
end
