desc "This task is called by the Heroku scheduler add-on"
task :clean_sessions => :environment do
  puts "Cleaning Sessions..."
  Session.all.each do |s|
    if not s.clean?
      puts "Deleting #{s}"
      s.destroy
    end
  end
end