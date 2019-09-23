require 'open-uri'

class HtmlCityParser
  CITY_HTML_URL = 'http://www.latlong.net/category/cities-102-15.html'.freeze
  attr_reader :cities
  def initialize 
    puts "dsd"
    @url = CITY_HTML_URL
    @cities = []
  end

  def call
    html_doc = read_html_file
    parse_cities(html_doc)
  end
  
  private
  def read_html_file
    Nokogiri::HTML(open(CITY_HTML_URL))
  end

  def parse_cities(html_doc)
    html_doc.search('table tr').each do |row|
      city = {}
      row.search('td').each_with_index do |data, index|
        city.merge!(parse_row_content(index, data.content))
      end
      @cities << city if city.present?
    end    
  end

  def parse_row_content(index, data)
    case index
    when 0
      return city_hash(data)
    when 1
      return {lat: data}
    when 2
      return {lng: data}
    end
    {}
  end

  def city_hash(data)
    city, state, country = data.split(',').map(&:strip)
    {
      city: city,
      state: state,
      country: country
    }
  end
end