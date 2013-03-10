class CreateConnectionsLinkedinusers < ActiveRecord::Migration
  def change
    create_table :connections_linkedinusers, :id => false do |t|
      t.integer :linkedinuser_id
      t.integer :connection_id

      t.timestamps
    end
  end
end
