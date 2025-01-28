class ChangeIndustryFromStringToInteger < ActiveRecord::Migration[7.2]
  def up
    # First, add a temporary column
    add_column :candidates, :industry_temp, :integer

    # Update the temporary column based on the first value in the industries array
    Candidate.find_each do |candidate|
      first_industry = candidate.industries&.first
      industry_value = case first_industry&.downcase
      when /it|software/i then 0
      when /marketing|sales/i then 1
      when /finance|accounting/i then 2
      when /human resources|hr/i then 3
      when /engineering|architecture/i then 4
      when /legal|compliance/i then 5
      when /health|fitness/i then 6
      when /education|training/i then 7
      else 8 # Other
      end
      candidate.update_column(:industry_temp, industry_value)
    end

    # Remove the old column and rename the temporary one
    remove_column :candidates, :industries
    rename_column :candidates, :industry_temp, :industries
  end

  def down
    # Add back the original array column
    add_column :candidates, :industries_temp, :text, array: true, default: []

    # Convert integer back to array with single value
    Candidate.find_each do |candidate|
      industry_string = case candidate.industries
      when 0 then [ 'it_and_software' ]
      when 1 then [ 'marketing_and_sales' ]
      when 2 then [ 'finance_and_accounting' ]
      when 3 then [ 'human_resources' ]
      when 4 then [ 'engineering_and_architecture' ]
      when 5 then [ 'legal_and_compliance' ]
      when 6 then [ 'health_and_fitness' ]
      when 7 then [ 'education_and_training' ]
      else [ 'other' ]
      end
      candidate.update_column(:industries_temp, industry_string)
    end

    # Remove the integer column and rename the temporary one
    remove_column :candidates, :industries
    rename_column :candidates, :industries_temp, :industries
  end
end
