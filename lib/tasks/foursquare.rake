 namespace :foursquare do

  desc "Query foursquare data"
  task :query_foursquare_data => :environment do
    client = Foursquare.client

    lat_amount = 20
    lng_amount = 40

    lat_start = 21.74
    lat_end   = 25.45
    
    lng_start = 120.12
    lng_end   = 121.97

    lat_interval = (lat_end - lat_start) / lat_amount
    lng_interval = (lng_end - lng_start) / lng_amount


    for i in 0..lat_amount
      lat = lat_start + lat_interval * i

      for j in 0..lng_amount
        lng = lng_start + lng_interval * j
        p "#{lat},#{lng}"
        FoursquareQueryService.new(lat, lng).run
        sleep(2)
      end

    end
    



  end



end
