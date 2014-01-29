class FoursquareQueryService

  def initialize(lat, lng)
    @client = Foursquare.client
    @lat = lat
    @lng = lng
  end

  def find_foursquare_model(foursquare_id)
    Foursquare.find_by_foursquare_id(foursquare_id)
  end

  def query_foursquare_datas
    @client.search_venues_by_tip(:ll => "#{@lat},#{@lng}", :query => 'coffee')
  end

  def query_foursquare_data(foursquare_id)
    @client.venue(foursquare_id)
  end

  def run

    query_foursquare_datas.each do |data|
      foursquare_id = data.id


      foursquare = find_foursquare_model(foursquare_id)

      if !foursquare
        foursquare_data = query_foursquare_data(foursquare_id)

        foursquare = Foursquare.new
        foursquare.foursquare_id = foursquare_id
        foursquare.foursquare_data = foursquare_data.to_json
        foursquare.rating = foursquare_data.rating

        foursquare.save
      end

    end


  end

end