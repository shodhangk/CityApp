require 'html_city_parser'
class ImportHtmlData < ActiveRecord::Migration[5.2]
  def up
    add_column :cities, :lat, :decimal, {:precision=>8, :scale=>6}
    add_column :cities, :lng, :decimal, {:precision=>8, :scale=>6}
 
    # add a CHECK constraint
    city_parser = HtmlCityParser.new
    city_parser.call
    cities = city_parser.cities

    cities.each  do |parsed_city|
      city = City.find_or_create_by(name: parsed_city[:name], state: parsed_city[:state],
                                    country: parsed_city[:country])
      city.update_attributes!({lat: parsed_city[:lat], lng: parsed_city[:lng]})
    end
  end
 
  def down
    remove_column :cities, :lat
    remove_column :cities, :lng
  end
end

