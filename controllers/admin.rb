# Admin controllers

# OAuth /connect & /auth are under controllers/oauth.rb

# Admin dashboard
get '/admin' do
  require_administrative_privileges

  haml :'admin/index'
end


get '/admin/location' do
  require_administrative_privileges
  @posts = []
  @users = User.all
  @trip = Trip.first rescue nil

  unless @trip.blank?
    @users.each do |user|
      begin
        @posts << "For #{user.screen_name}:"
        twitter_connect(user)

        tweets = @twitter_client.user_timeline
        tweets.each do |tweet|
          # Using Twitter's geo code
          if !tweet['geo'].blank?
            # Version 1 - Lat / Lon -- this will change with Version 2 of API to reflect GeoJSON specs!!!
            position = tweet['geo']['coordinates'].join(', ')

          # Backwards compat for other apps, like twibble, that put the lat/lon in the tweet
          elsif tweet['text'].match(/L:[\d\.\,]+/)
            position = tweet['text'].gsub(/^(.*)(L:)([\d\.,]+)(.*)$/, '\3')
          end

          unless position.blank?
            loc = Location.first_or_create(:tweet_id => tweet['id'], :user_id => user.id, :position => position, :trip_id => @trip.id)
            @posts << "Location found for #{tweet['id']} &gt; #{position}"
          else
            @posts << "No location data for #{tweet['id']}."
          end
        end

      rescue
        (@errors ||= []) << "<strong>#{$! || "There was an error getting timeline"} for @#{user.screen_name}.</strong>"
      end
    end
  end

  @posts = @posts.join('<br />')

  haml :'admin/location'
end