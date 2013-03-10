class CreateCompaniesLinkedinusers < ActiveRecord::Migration
  def up
    create_table :companies_linkedinusers, :id => false do |t|
      t.integer :company_id
      t.integer :linkedinuser_id
    end
  end

  def down
    drop_table :companies_linkedinusers
  end
end
