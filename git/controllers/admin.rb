# Admin controllers

# OAuth /connect & /auth are under controllers/oauth.rb

# Admin dashboard
get '/admin' do
  require_administrative_privileges

  haml :'admin/index'
end


get '/admin/location' do
  require_administrative_privileges

  @users = User.all
  @users.each do |user|
    # begin
      twitter_connect(user)

      tweets = @twitter_client.user_timeline
      tweets.each do |tweet|
        if tweet['text'].match(/L:[\d\.\,]+/)
          position = tweet['text'].gsub(/^(.*)(L:)([\d\.,]+)(.*)$/, '\3')
          loc = Location.first_or_create(:tweet_id => tweet['id'], :user_id => user.id, :position => position, :trip_id => 1)
        end
      end

    # rescue
    #   (@errors ||= []) << "<strong>#{$! || "There was an error getting timeline"} for @#{user.screen_name}.</strong>"
    # end
  end


  haml :'admin/location'
end