class LinkedinusersCompanies < ActiveRecord::Migration
  def change
    create_table :linkedinusers_companies do |t|
      t.integer :linkedinuser_id
      t.integer :company_id

      t.timestamps
    end
  end
end
