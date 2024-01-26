require_relative './parse_csv.rb'


# FYI: comma separated values
IMPORT_FILE_MODELS = "model-import.csv"
IMPORT_FILE_ITEMS = "items-import.csv"

DEFAULT_RETIRED_REASON = "retired"

module ModelKeys
  MODEL = "model"
  MANUFACTURER = "supplier"
  TECHNICAL_DETAILS = "technical_detail"
  DESCRIPTION = "description"
end

module ItemKeys
  NAME = "name"
  SERIAL_NUMBER = "serial_number"
  RETIRED = "retired"
  IS_BROKEN = "is_broken"
  OWNER = "owner"
  RESPONSIBLE_DEPARTMENT = "inventory_pool"
  BUILDING = "building"
  ROOM = "room"
  PROPERTIES = "properties_installation_status"
  MODEL = "model"
end

def print_csv_model_row(row)
  puts "----> print_csv_model_row "
  # puts row['model']
  # puts row[ModelKeys::MODEL.to_s]
  puts row[ModelKeys::MODEL]
  puts "----------"
  puts row[ModelKeys::MANUFACTURER]
  puts row[ModelKeys::TECHNICAL_DETAILS]
  puts row[ModelKeys::DESCRIPTION]
end

def to_bool(value)
  !!value
end

def import_models_from_csv(error_map)
  csv_parser = CSVParser.new(IMPORT_FILE_MODELS)
  csv_parser.for_each_row do |row|
    puts "csv-row _> #{row}"
    # puts "----"
    #
    print_csv_model_row(row)

    puts "---- ??? #{ModelKeys::MODEL}  "

    model_name = "test-#{row[ModelKeys::MODEL]}"
    puts "model_name???: #{model_name}"

    model_attributes = {
      # product: row[ModelKeys::MODEL],  # TODO: revert to this
      product: model_name,
      manufacturer: row[ModelKeys::MANUFACTURER],
      technical_detail: row[ModelKeys::TECHNICAL_DETAILS],
      description: row[ModelKeys::DESCRIPTION]
    }

    begin
      Model.create(model_attributes).save!
    rescue => e
      error_map["model/#{model_attributes[:product]}"] = { 'data': model_attributes, 'error': e.message }
    end

  end
end

def import_items_from_csv(error_map)
  csv_parser = CSVParser.new(IMPORT_FILE_ITEMS)
  csv_parser.for_each_row do |row|
    puts row
    puts "----"

    # model_name = row[ModelKeys::MODEL]                # TODO: revert to this
    model_name = "test-#{row[ModelKeys::MODEL]}"
    puts "model_name: #{model_name}"

    owner_name = row[ItemKeys::OWNER]
    puts "owner_name: #{owner_name}"

    is_retired = to_bool(row[ItemKeys::RETIRED])
    puts "is_retired1: #{is_retired}"
    puts "is_retired2: #{is_retired.class}"

    responsible_department_name = row[ItemKeys::RESPONSIBLE_DEPARTMENT]
    puts "responsible_department_name: #{responsible_department_name}"

    building_name = row[ItemKeys::BUILDING]
    puts "building_name: #{building_name}"

    # extract building.name & building.code from building_name "<building.name> (<building.code>)"
    building_name_extracted = building_name.match(/^(.*)\s\((.*)\)$/)[1]
    building_code_extracted = building_name.match(/^(.*)\s\((.*)\)$/)[2]
    puts "building_name_extracted: #{building_name_extracted}"
    puts "building_code_extracted: #{building_code_extracted}"

    room_name = row[ItemKeys::ROOM]
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
      # name: "#{row[ItemKeys::NAME]}",          # TODO: revert to this
      name: "test-#{row[ItemKeys::NAME]}",

      serial_number: row[ItemKeys::SERIAL_NUMBER],
      is_broken: to_bool(row[ItemKeys::IS_BROKEN]),
      owner_id: owner_rec.id,
      inventory_pool_id: responsible_department_name_rec.id,
      room_id: room_rec.id,
      properties: { 'key' => row[ItemKeys::PROPERTIES] },
      model_id: model_rec.id
    }

    # FIXME / FYI: there is no "retired" attribute on the Item model
    if is_retired
      item_attributes[:retired] = Time.now
      item_attributes[:retired_reason] = DEFAULT_RETIRED_REASON
    end

    begin
      Item.create(item_attributes).save!
    rescue => e
      error_map["items/#{item_attributes[:name]}"] = { 'data': item_attributes, 'error': e.message }
    end

  end
end

def log_errors_and_rollback(error_map)
  puts "====== ERRORS ========"
  puts "#{error_map.length} errors occurred"
  puts error_map.to_json
  puts "======================"

  raise ActiveRecord::Rollback
end

def import_models_and_items
  ActiveRecord::Base.transaction do
    error_map = {}

    import_models_from_csv(error_map)
    import_items_from_csv(error_map)

    if error_map.length > 0 then
      log_errors_and_rollback(error_map)
    end

    puts "----- INFO: IMPORT-PROCESS COMPLETED -----"
  end
end

import_models_and_items
