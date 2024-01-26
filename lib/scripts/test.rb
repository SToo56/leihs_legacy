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

def to_bool(value)
  !!value
end

def import_models_from_csv(error_map)
  csv_parser = CSVParser.new("model-import.csv")
  # csv_parser = CSVParser.new("model-import-errors.csv")
  csv_parser.for_each_row do |row|
    puts row
    puts "----"

    print_csv_model_row(row)

    model_name = "test-#{row['model']}"

    # Insert a new record into the Model table

    model_attributes = {
      # product: row['model'],
      product: model_name,
      manufacturer: row['supplier'],
      technical_detail: row['technische details'],
      description: row['description']
    }

    begin
      Model.create(model_attributes).save!
    rescue => e
      error_map["model/#{model_attributes[:product]}"] = { 'data': model_attributes, 'error': e.message }
    end

  end
end

def import_items_from_csv(error_map)
  csv_parser = CSVParser.new("items-import.csv")
  csv_parser.for_each_row do |row|
    puts row
    puts "----"

    # model_name = row['model']
    model_name = "test-#{row['model']}"
    puts "model_name: #{model_name}"

    owner_name = row['owner']
    puts "owner_name: #{owner_name}"

    is_retired = to_bool(row['retired'])
    puts "is_retired1: #{is_retired}"
    puts "is_retired2: #{is_retired.class}"

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

    model_rec = Model.find_by!(product: model_name)
    puts "model_rec: #{model_rec}"

    puts "owner_rec.name: ??? >#{owner_name}<"
    owner_rec = InventoryPool.find_by!(name: owner_name)
    puts "owner_rec: #{owner_rec}"

    responsible_department_name_rec = InventoryPool.find_by!(name: responsible_department_name)
    puts "responsible_department_name_rec: #{responsible_department_name_rec}"

    building_rec = Building.find_by!(name: building_name_extracted, code: building_code_extracted)
    # building_name_with_code= "#{building_rec.name} (#{building_rec.code})"
    puts "building_rec: #{building_rec}"
    # puts "building_name_with_code: #{building_name_with_code}"

    room_rec = Room.find_by!(building_id: building_rec.id, name: room_name)
    puts "building_rec: #{room_rec}"

    item_attributes = {
      name: "test-#{row['name']}",
      serial_number: row['serial_number'],
      is_broken: to_bool(row['is_broken']),
      owner_id: owner_rec.id,
      inventory_pool_id: responsible_department_name_rec.id,
      room_id: room_rec.id,
      properties: { 'key' => row['properties_installation_status'] },
      model_id: model_rec.id
    }

    # FIXME / FYI: there is no "retired" attribute on the Item model
    if is_retired
      item_attributes[:retired] = Time.now
      item_attributes[:retired_reason] = "retired"
    end

    # Create the Item with the defined attributes
    begin
      Item.create(item_attributes).save!
    rescue => e
      error_map["items/#{item_attributes[:name]}"] = { 'data': item_attributes, 'error': e.message }
    end

  end
end

def import_models_and_items
  ActiveRecord::Base.transaction do
    error_map = {}

    # parse data from csv
    import_models_from_csv(error_map)

    # parse data from csv
    import_items_from_csv(error_map)

    if error_map.length > 0 then
      puts "====== ERRORS ========"
      puts "#{error_map.length} errors occurred"
      puts error_map.to_json
      puts "======================"

      raise ActiveRecord::Rollback
    end

    puts "----- INFO: IMPORT-PROCESS COMPLETED -----"
  end
end

import_models_and_items
