class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :company_linkedin_id
      t.string :company_linkedin_name

      t.timestamps
    end
  end
end
