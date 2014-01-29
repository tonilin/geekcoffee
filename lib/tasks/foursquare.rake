namespace :foursquare do

  desc "Query foursquare data"
  task :query_foursquare_data => :environment do
    client = Foursquare.client

    lat = 25.068462
    lng = 121.497408

    FoursquareQueryService.new(lat, lng).run

  end



end
