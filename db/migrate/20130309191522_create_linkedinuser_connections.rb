class CreateLinkedinuserConnections < ActiveRecord::Migration
  def change
    create_table :linkedinuser_connections do |t|
      t.integer :linkedinuser_id
      t.integer :connection_id

      t.timestamps
    end
  end
end
