class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :position_linkedin_id
      t.string :title
      t.text :summary
      t.boolean :is_current
      t.integer :linkedinuser_id
      t.integer :company_linkedin_id

      t.timestamps
    end
  end
end
