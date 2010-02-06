# Public controllers

# Homepage
get '/' do
  # cache "homepage/#{@user.blank? ? 'guest' : 'user'}", :expiry => 600, :compress => true do
    @meta_refresh = 120
    @trips = Trip.all(:order => [:created_at.asc])
    haml :'public/home'
  # end
end


get '/:id' do
  @meta_refresh = 120
  @trip = Trip.first(:id => params[:id]) rescue nil
  haml :'public/trip'
end


get '/embed/:id' do
  @embed = true
  @trip = Trip.first(:id => params[:id]) rescue nil
  haml :'public/embed', :layout => :embed
end