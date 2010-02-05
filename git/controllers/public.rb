# Public controllers

# Homepage
get '/' do
  # cache "homepage/#{@user.blank? ? 'guest' : 'user'}", :expiry => 600, :compress => true do
    @trips = Trip.all(:order => [:created_at.asc])
    
    haml :'public/home'
  # end
end