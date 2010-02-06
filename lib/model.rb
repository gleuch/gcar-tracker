class User
  include DataMapper::Resource

  property :id,               Serial
  property :account_id,       Integer
  property :screen_name,      String
  property :oauth_token,      String
  property :oauth_secret,     String
  property :active,           Boolean,    :default => true
  property :created_at,       DateTime
  property :updated_at,       DateTime

  has n, :location
    
end

class Trip
  include DataMapper::Resource

  property :id,               Serial
  property :name,             String
  property :description,      Text
  property :created_at,       DateTime
  property :updated_at,       DateTime
  property :active,           Boolean,    :default => true
  property :timezone_offset,   Integer,    :default => 0

  has n, :location
end

class Location
  include DataMapper::Resource

  property :id,               Serial
  property :tweet_id,         String # So large, needs to be string!
  property :position,         String
  property :user_id,          Integer
  property :trip_id,          Integer
  property :note,             Text
  property :created_at,       DateTime
  property :updated_at,       DateTime

  belongs_to :user
  belongs_to :trip

  # validates_with_method :check_duplicate

  def check_duplicate
    check = Location.first(:trip_id => self.trip_id, :position => self.position) rescue nil
    unless check.blank?
      return true
    else
      return [false, 'Duplicate location for this trip.']
    end
  end


end