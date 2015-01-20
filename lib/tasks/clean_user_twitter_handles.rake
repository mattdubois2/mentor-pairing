namespace :users do
  desc "Clean user twitter handles if invalid"
  task :clean_twitter => :environment do
    users = User.all.select { |u| u.twitter_handle !~ /\A[a-zA-Z0-9_]{1,15}\z/ }
    users.each do |u|
      u.update(twitter_handle: CleanTwitter.fix_handle(u.twitter_handle))
    end
  end
end
