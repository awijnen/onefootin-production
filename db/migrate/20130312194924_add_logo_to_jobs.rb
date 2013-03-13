class AddLogoToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :logo, :binary
  end
end
