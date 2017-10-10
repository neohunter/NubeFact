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

  def dollar_rate(time = Time.now)
    @dollar ||= update_dollar_rate
  end

  def update_dollar_rate(time = Time.now)
    dollar_from_sunat(time) rescue dollar_from_preciodolar(time)
  end

  def dollar_from_sunat(time = Time.now)
    doc = Nokogiri::HTML(open("http://www.sunat.gob.pe/cl-at-ittipcam/tcS01Alias?mes=#{time.month}&anho=#{time.year}"))
    begin
      rate = doc.at("td.H3 strong:contains(#{time.day})").parent.parent.at('td:last').text.strip
    rescue
      warn "Not able to get for the specific day #{time}, using the latest available"
      rate = doc.at ('td.tne10:last').text.strip
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
end