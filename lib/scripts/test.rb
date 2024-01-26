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

def print_csv_model_row(row)
  puts row['model']
  puts row['supplier']
  puts row['technische details']
  puts row['description']
end

def import_models
  csv_parser = CSVParser.new("model-import.csv")
  # csv_parser = CSVParser.new("model-import-errors.csv")
  csv_parser.for_each_row do |row|
    puts row
    puts "----"

    print_csv_model_row(row)

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
    # model_rec = Model.find_by(product: row['model'])
    fetched_model = Model.find_by(product: model_name)

    puts "?model: #{fetched_model}"
    puts "?model: #{fetched_model.id}"

    # break

  end
end

def import_models_items
  ActiveRecord::Base.transaction do

    # parse data from csv
    # import_models

    # parse data from csv
    csv_parser = CSVParser.new("items-import.csv")
    csv_parser.for_each_row do |row|
      puts row
      puts "----"

      # model_name = row['model']
      model_name = "test-#{row['model']}"
      puts "model_name: #{model_name}"

      owner_name = row['owner']
      puts "owner_name: #{owner_name}"

      responsible_department_name = row['Verantwortliche Abteilung']
      puts "responsible_department_name: #{responsible_department_name}"

      building_name = row['Gebäude']
      puts "building_name: #{building_name}"

      # extract building.name & building.code from building_name "<building.name> (<building.code>)"
      building_name_extracted = building_name.match(/^(.*)\s\((.*)\)$/)[1]
      building_code_extracted = building_name.match(/^(.*)\s\((.*)\)$/)[2]
      puts "building_name_extracted: #{building_name_extracted}"
      puts "building_code_extracted: #{building_code_extracted}"


      room_name = row['Raum']
      puts "room_name: #{room_name}"


      puts "----"


      model_rec = Model.find_by(product: model_name)
      puts "model_rec: #{model_rec}"

      puts "owner_rec.name: ??? >#{owner_name}<"
      owner_rec = InventoryPool.find_by(name: owner_name)
      puts "owner_rec: #{owner_rec}"

      responsible_department_name_rec = InventoryPool.find_by(name: responsible_department_name)
      puts "responsible_department_name_rec: #{responsible_department_name_rec}"

      building_rec = Building.find_by(name: building_name_extracted, code: building_code_extracted)
      # building_name_with_code= "#{building_rec.name} (#{building_rec.code})"
      puts "building_rec: #{building_rec}"
      # puts "building_name_with_code: #{building_name_with_code}"

      room_rec = Room.find_by(building_id: building_rec.id, name: room_name)
      puts "building_rec: #{room_rec}"

      model = Item.create(
        # name:row['name'],
        name: "test-#{row['name']}",
        serial_number: row['serial_number'],
        retired: row['retired'],           # TODO: retired = true
        is_broken: row['is_broken'],
        owner_id: owner_rec.id,
        inventory_pool_id: responsible_department_name_rec.id, # TODO: Verantwortliche Abteilung?
        room_id: room_rec.id,
        # properties: "{'key': #{row['properties_installation_status']}}",
        # properties: "{'key': #{row['properties_installation_status']}}",
        properties: { 'key' => row['properties_installation_status'] },
        model_id: model_rec.id
      ).save!

      break
    end


    puts "----- IMPORT-PROCESS COMPLETED -----"

    # Optionally, raise ActiveRecord::Rollback under certain conditions to undo the transaction
    # raise ActiveRecord::Rollback if some_condition
  end
end





# # Retrieve all records from InventoryPool
# inventory_pools = InventoryPool.all
#
# # Loop through each record
# inventory_pools.each do |owner_rec|
#   puts "owner_rec: #{owner_rec}"
# end
#
# # Fetch the first record (or any other record)
# owner_rec = InventoryPool.first
#   puts "?? val: #{owner_rec.name}"
#
# # Check if the record exists and then print the keys
# if owner_rec
#   puts "Keys: #{owner_rec.attribute_names.join(', ')}"
# else
#   puts "No records found in InventoryPool."
# end



# Start an ActiveRecord transaction
import_models_items







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