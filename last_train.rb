require 'date'
require 'json'
require 'net/http'

API_KEY = ENV['API_KEY']

def last_dwell(stop, from_datetime, to_datetime)
  url = "http://realtime.mbta.com/developer/api/v2.1/dwells?api_key=#{API_KEY}&format=json&stop=#{stop}&from_datetime=#{from_datetime}&to_datetime=#{to_datetime}"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  trains = JSON.parse(response)

  train = trains["dwell_times"] ? trains['dwell_times'].last : nil
  if train
    arrival = Time.at(train['arr_dt'].to_i)
    departure = Time.at(train['dep_dt'].to_i)
    dwell_time = train['dwell_time_sec']
    puts "#{train['route_id']}: #{arrival} to #{departure} (#{dwell_time} seconds)"
  end
end

def last_dwell_for_day(stop, midnight)
  two_am = DateTime.new(midnight.year, midnight.month, midnight.day, 2, 0, 0, midnight.zone)
  last_dwell(stop, midnight.to_time.to_i, two_am.to_time.to_i)
end

def last_dwells_for_days(stop, last_day_midnight, num_days)
  num_days.times do |i|
    last_dwell_for_day(stop, last_day_midnight - i)
  end
end

now = DateTime.now
midnight_today = DateTime.new(now.year, now.month, now.day, 0, 0, 0, now.zone)

core_stops = {
  'Park Street - to Ashmont/Braintree' => '70075',
  'Park Street - to Alewife' => '70076',
  'Park Street - Green Line - B Branch Berth' => '70196',
  'Park Street - Green Line - C Branch Berth' => '70197',
  'Park Street - Green Line - D Branch Berth' => '70198',
  'Park Street - Green Line - E Branch Berth' => '70199',
  'Park Street - Green Line Eastbound' => '70200',
  'Government Center - to Wonderland' => '70040',
  'Downtown Crossing - to Forest Hills' => '70020',
  'Downtown Crossing - to Oak Grove' => '70021',
}

just_past_core_stops = {
  'Aquarium - Outbound' => '70044',
  'South Station - Outbound' => '70079',
  'Charles/MGH - Outbound' => '70074',
  'Chinatown - Outbound' => 70018,
  'Haymarket - Orange Line Outbound' => 70025,
  'Boylston - Outbound' => 70159,
}

all_stops = core_stops.merge(just_past_core_stops)

all_stops.each do |description, code|
  puts "Last trains each night for #{description} (stop id #{code}):"
  last_dwells_for_days(code, midnight_today, 30)
  puts
end
