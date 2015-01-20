

namespace :users do
  desc "Clean user twitter handles if invalid"
  task :clean_twitter => :environment do
    invalid_users = []
    User.all.each do |user|
      if user.twitter_handle !~ /\A[a-zA-Z0-9_]{1,15}\z/
        invalid_users << user
      end
    end
    invalid_users.each do |user|
      user.twitter_handle.sub(/^@/, "")
      user.twitter_handle.sub(/^.*\/+/, "")
      user.save
    end
  end
end
