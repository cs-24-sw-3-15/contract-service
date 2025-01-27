namespace :db do
  desc "Run custom seed"
  task custom_seed: :environment do
    custom_seed_file = Rails.root.join("db", "custom_seed.rb")
    if File.exist?(custom_seed_file)
      puts "Loading custom seeds..."
      load custom_seed_file
      puts "Custom seeds loaded successfully."
    else
      puts "No custom seeds file found at #{custom_seed_file}"
    end
  end
end
