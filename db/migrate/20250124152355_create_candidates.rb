class CreateCandidates < ActiveRecord::Migration[7.2]
  def change
    create_table :candidates do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :contact_number, null: false
      t.datetime :dob, null: false
      t.string :education, null: false
      t.string :experience, null: false
      t.string :expected_salary, null: false
      t.string :career_phase, null: false
      t.string :additional_notes
      t.text :industries, array: true, default: []
      t.timestamps
    end
  end
end
