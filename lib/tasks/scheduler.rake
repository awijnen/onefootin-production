desc "This task is called by the Heroku scheduler add-on"

task :update_database => [:drop_database] do
  puts "Updating database..."
  Job.create_all_from_simply_hired
  puts "done."
end

task :drop_database => [:environment] do
  puts "Dropping database ..."

  puts "Done"
end