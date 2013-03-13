class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.datetime :posting_date
      t.string :link
      t.string :city
      t.string :state
      t.integer :company_id
      t.string :logo
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
