require 'bigdecimal'
require 'date'
require 'nokogiri'
require 'open-uri'

# ==== WARNING WIP
# This is a very basic implementation to obtain sunat dollar exchange rate.
# I wrote it really quick. Please don't rely on it.
# It currently uses two providers. there is no guarantee that the will work, or 
# the response format will change.
# ==== WARNING WIP

module NubeFact::Sunat
  extend self

  def dollar_rate(date = Date.today)
    begin
      dollar_from_sunat(date)
    rescue => e
      # only rely on preciodolar for current day
      raise e unless date == Date.today
      
      dollar_from_preciodolar
    end
  end

  def dollar_from_sunat(date = Date.today)
    raise InvalidDate if date.year < 2000 || date.year > Time.now.year

    doc = Nokogiri::HTML(open("https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mes=#{date.month}&anho=#{date.year}")) do |config|
      config.noblanks
    end

    result = {}
    day = nil
    doc.css('td.H3, td.tne10').each do |td|
      if day
        result[day] << td.text.strip
        day = nil if result[day].count == 2
      else
        day = td.at(:strong).text.strip.to_i
        result[day] = []
      end
    end

    # result is {day: [buy, sell], day: [buy, sell]}

    if result[date.day]
      rate = result[date.day].last # venta
    else
      # try to get the nearest day.
      i = 0
      while i < date.day
        if result[i]
           rate = result[i].last
        end
        i += 1
      end

      unless rate
        # not possible to get the previous date, lests why with previous month
        prev_month = date.to_datetime.prev_month
        prev_month = Date.new(prev_month.year, prev_month.month, -1)
        warn "Checking with previous month #{prev_month}"
        rate = dollar_from_sunat(prev_month)
      end
    end

    BigDecimal.new(rate)
  end


  def dollar_from_preciodolar
    url = URI("https://api.preciodolar.com/api/history/?time_interval=day&country=pe&bank_id=13&source=bank")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    response = http.request request
    result = JSON.parse(response.read_body)

    result.last["sell"]
  end

  class InvalidDate < StandardError; end;
end