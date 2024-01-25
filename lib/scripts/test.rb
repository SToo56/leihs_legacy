# require_relative '../path/to/csv_parser'
require_relative './parse_csv.rb'

# bundle exec rails runner lib/scripts/test.rb
puts "servus du"
puts "---------------------------------"




mc = Model.count
ic = Item.count
puts("Model count is: #{mc}\n")
puts("Item count is: #{ic}")
puts "---------------------------------"



# parse data from csv
csv_parser = CSVParser.new("model-import.csv")
csv_parser.for_each_row do |row|
 puts row
end

