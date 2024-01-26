# require_relative '../path/to/csv_parser'
require_relative './parse_csv.rb'

# bundle exec rails runner lib/scripts/test.rb
puts "servus du"
puts "---------------------------------"


# ActiveRecord::Base.transaction do
#  # Your database operations go here
#  # For example, creating or updating records
#
#  # If an error occurs, you can raise an ActiveRecord::Rollback to trigger a rollback
#  raise ActiveRecord::Rollback if true == true
#
#  # If an unhandled exception occurs, the transaction will also rollback
# end


# # Start an ActiveRecord transaction
# ActiveRecord::Base.transaction do
#  # Insert a new record into the Model table
#  Model.create(attribute1: value1, attribute2: value2, ...)
#
#  # Optionally, raise ActiveRecord::Rollback under certain conditions to undo the transaction
#  raise ActiveRecord::Rollback if some_condition
# end



# mc = Model.count
# ic = Item.count
# puts("Model count is: #{mc}\n")
# puts("Item count is: #{ic}")
puts "---------------------------------"


# Start an ActiveRecord transaction
ActiveRecord::Base.transaction do

 # parse data from csv
 csv_parser = CSVParser.new("model-import.csv")
 # csv_parser = CSVParser.new("model-import-errors.csv")
 csv_parser.for_each_row do |row|
  puts row
  puts "----"
  # puts row['product']
  # puts row['manufacturer']
  # puts row['technical_details']
  # puts row['description']

  puts row['model']
  puts row['supplier']
  puts row['technische details']
  puts row['description']


  model_name = "test-#{row['model']}"

 # Insert a new record into the Model table
  model = Model.create(
    # product: row['model'],
    product: model_name,
    manufacturer: row['supplier'],
    technical_detail: row['technische details'],
    description: row['description']
  ).save!

  # Fetch a record
  # fetched_model = Model.find_by(product: row['model'])
  fetched_model = Model.find_by(product: model_name)

  puts "?model: #{fetched_model}"
  puts "?model: #{fetched_model.id}"

  # break

 end



 # Optionally, raise ActiveRecord::Rollback under certain conditions to undo the transaction
 # raise ActiveRecord::Rollback if some_condition
end


# # parse data from csv
# # csv_parser = CSVParser.new("model-import.csv")
# csv_parser = CSVParser.new("model-import-errors.csv")
# csv_parser.for_each_row do |row|
#  puts row
#
#  break
#
# end


# 1. insert all models (and log)
# 2. insert all items (and log)
# 3. If error happened, rollback and log error