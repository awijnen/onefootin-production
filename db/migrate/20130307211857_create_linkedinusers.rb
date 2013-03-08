class CreateLinkedinusers < ActiveRecord::Migration
  def change
    create_table :linkedinusers do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :linkedin_id
      t.string :location
      t.integer :num_connections
      t.string :picture_url
      t.string :public_profile_url
      t.integer :separation_degree
      t.integer :total_positions
      t.integer :user_id

      t.timestamps
    end
  end
end
