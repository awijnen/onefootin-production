class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.text :title
      t.datetime :posting_date
      t.text :link
      t.string :city
      t.string :state
      t.integer :company_id
      t.string :logo
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
