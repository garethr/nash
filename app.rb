require 'sinatra'

require 'net/http'
require 'hpricot'


NAGIOS_HOST = ENV['NAGIOS_HOST']
USERNAME = ENV['AUTH_USERNAME']
PASSWORD = ENV['AUTH_PASSWORD']

use Rack::Auth::Basic, "Restricted" do |username, password|
  [username, password] == [USERNAME, PASSWORD]
end

get '/' do
  begin
    response = Net::HTTP.start(NAGIOS_HOST) {|http|
      req = Net::HTTP::Get.new('/cgi-bin/nagios3/status.cgi?hostgroup=all&style=overview')
      req.basic_auth USERNAME, PASSWORD
      http.request(req)
    }

    doc = Hpricot(response.body)

    counts = []

    count_elements = doc.search("table.serviceTotals tr:nth(1) td")

    count_elements.each do |element|
      counts << element.inner_text
    end

    @totals = {
      :ok => counts[0],
      :warning => counts[1],
      :critical => counts[3],
      :total => counts[6]
    }

    @state = if @totals[:critical].to_i > 0
      "critical"
    elsif @totals[:warning].to_i > 0
      "warning"
    else
      "ok"
    end

    erb :index
  rescue
    erb :error
  end
end
