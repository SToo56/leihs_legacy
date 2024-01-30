require_relative './parse_csv.rb'
require 'date'


# RUN: bundle exec rails runner lib/scripts/import_models_and_items.rb

# FYI: comma separated values
IMPORT_FILE_MODELS = "model-import.csv"
IMPORT_FILE_ITEMS = "items-import.csv"

PROPERTY_KEY_INSTALLATION_STATUS = "installation_status"
DEFAULT_RETIRED_REASON = "retired"

module ModelKeys
  MODEL = "model"
  MANUFACTURER = "supplier"
  TECHNICAL_DETAILS = "technical_detail"
  DESCRIPTION = "description"
end

module ItemKeys
  NOTE = "note"
  SERIAL_NUMBER = "serial_number"
  RETIRED = "retired"
  IS_BROKEN = "is_broken"
  OWNER = "owner"
  RESPONSIBLE_DEPARTMENT = "inventory_pool"
  BUILDING = "building"
  ROOM = "room"
  PROPERTIES = "properties_installation_status"
  MODEL = "model"
  INVENTORY_CODE = "inventory_code"
end

def print_csv_model_row(row)
  puts "----> print_csv_model_row "
  puts row[ModelKeys::MODEL]
  puts "----------"
  puts row[ModelKeys::MANUFACTURER]
  puts row[ModelKeys::TECHNICAL_DETAILS]
  puts row[ModelKeys::DESCRIPTION]
end

def to_bool(str)
  case str.downcase
  when 'true', 't', 'yes', 'y', '1'
    true
  when 'false', 'f', 'no', 'n', '0'
    false
  else
    nil
  end
end

def gen_model_attributes(row)

  print_csv_model_row(row)

  model_name = "test-#{row[ModelKeys::MODEL]}"

  model_attributes = {
    # product: row[ModelKeys::MODEL],  # TODO: revert to this
    product: model_name,

    manufacturer: row[ModelKeys::MANUFACTURER],
    technical_detail: row[ModelKeys::TECHNICAL_DETAILS],
    description: row[ModelKeys::DESCRIPTION]
  }
  return model_attributes
end

def import_models_from_csv(error_map)
  csv_parser = CSVParser.new(IMPORT_FILE_MODELS)
  csv_parser.for_each_row do |row|
    model_attributes = gen_model_attributes(row)

    begin
      Model.create(model_attributes).save!
    rescue => e
      error_map["model/#{model_attributes[:product]}"] = { 'data': model_attributes, 'error': e.message }
    end
  end
end

def extract_building_name_and_code(building_name)
  building_name_extracted = building_name.match(/^(.*)\s\((.*)\)$/)[1]
  building_code_extracted = building_name.match(/^(.*)\s\((.*)\)$/)[2]

  return building_code_extracted, building_name_extracted
end

def generate_inventory_code(current_inventory_pool)
  # code here
  inventory_code=Item.proposed_inventory_code(current_inventory_pool, :lowest)

  puts ">>> inventory_code: #{inventory_code}"

  return inventory_code
end

def gen_item_attributes(row)
  # model_name = row[ModelKeys::MODEL]                # TODO: revert to this
  model_name = "test-#{row[ModelKeys::MODEL]}"
  puts "model_name: #{model_name}"

  owner_name = row[ItemKeys::OWNER]
  is_retired = to_bool(row[ItemKeys::RETIRED])
  responsible_department_name = row[ItemKeys::RESPONSIBLE_DEPARTMENT]

  building_name = row[ItemKeys::BUILDING]
  building_code_extracted, building_name_extracted = extract_building_name_and_code(building_name)
  puts "building_name_extracted: #{building_name_extracted}"
  puts "building_code_extracted: #{building_code_extracted}"

  room_name = row[ItemKeys::ROOM]
  model_rec = Model.find_by!(product: model_name)
  owner_rec = InventoryPool.find_by!(name: owner_name)
  responsible_department_name_rec = InventoryPool.find_by!(name: responsible_department_name)
  building_rec = Building.find_by!(name: building_name_extracted, code: building_code_extracted)
  room_rec = Room.find_by!(building_id: building_rec.id, name: room_name)

  item_attributes = {
    # name: "#{row[ItemKeys::INVENTORY_CODE]}",          # TODO: revert to this
    note: "test-#{row[ItemKeys::NOTE]}",
    inventory_code: generate_inventory_code(responsible_department_name_rec.id),
    serial_number: row[ItemKeys::SERIAL_NUMBER],
    is_broken: to_bool(row[ItemKeys::IS_BROKEN]),
    owner_id: owner_rec.id,
    inventory_pool_id: responsible_department_name_rec.id,
    room_id: room_rec.id,
    properties: { PROPERTY_KEY_INSTALLATION_STATUS => row[ItemKeys::PROPERTIES] },
    model_id: model_rec.id
  }

  # FIXME / FYI: there is no "retired" attribute on the Item model
  if is_retired
    item_attributes[:retired] = Date.today
    item_attributes[:retired_reason] = DEFAULT_RETIRED_REASON
  end

  item_attributes
end

def import_items_from_csv(error_map)
  csv_parser = CSVParser.new(IMPORT_FILE_ITEMS)
  csv_parser.for_each_row do |row|
    item_attributes = gen_item_attributes(row)

    begin
      Item.create(item_attributes).save!
    rescue => e
      error_map["items/#{item_attributes[:name]}"] = { 'data': item_attributes, 'error': e.message }
    end

    break;
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

    puts "----- INFO: IMPORT-PROCESS SUCCESSFULLY COMPLETED -----"
  end
end

import_models_and_items
