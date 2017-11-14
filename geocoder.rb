# coding: utf-8
require "rubygems"
require "bundler/setup"

require "csv"
require "geocoder"

Geocoder.configure(
  timeout: 3,
  lookup: :google,
  use_https: true,
  api_key: "AIzaSyAwBPxrD7iEdmnu6MuK2-bkFW3pVfHXpEA",
  units: :km
)

def geocode(address)
  results = Geocoder.search(clean(address))
  results.first if results.any?
end

def clean(address)
  if address && !address.empty?
    address.split(/\n+/).join(" ")
  end
end

output = []

CSV.foreach("locations.csv", col_sep: ";").with_index(1) do |row, i|
  location = [row[0]]

  log = "#{i}: processing: #{row[0]}… "

  if geocoded = geocode(row[1])
    log << "found address"

    location << geocoded.formatted_address
    location << geocoded.latitude
    location << geocoded.longitude
  else
    log << "could not find address"

    location << clean(row[1])
    location << ""
    location << ""
  end

  puts log

  location << row[2]
  location << row[3]
  location << row[4]

  output << location
end

# Write data
File.write("geocoded_locations.csv", output.map(&:to_csv).join)
File.write("locations.json", output.to_json)
