# coding: utf-8
require "rubygems"
require "bundler/setup"

require "csv"
require "json"

output = []

quote_chars = %w(" | ~ ^ & *)
begin
  rows = CSV.read("geocoded_locations.csv", headers: :first_row, quote_char: quote_chars.shift, col_sep: ";")
rescue CSV::MalformedCSVError
  quote_chars.empty? ? raise : retry
end

rows.each do |row|
  output << [row[0], row[1], Float(row[3]), Float(row[4]), row[5], row[2]]
end

# Write data
File.write("locations.json", output.to_json)
