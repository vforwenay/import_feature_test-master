require 'import_support'

class ImportInventory
	include ImportSupport

	def initialize(import_request_id)
		@import_request = ImportRequest.find(import_request_id)
	end

	def rows
		get_rows(@import_request.id)
	end

	def execute
    all_row_imported = true
    import_errors = []
    inventories = []
    imported_row_count = 0

    begin

    	case @import_request.import_for
    	when ImportRequest::IMPORT_FOR[:on_hand]
    		imported_row_count, import_errors, all_row_imported, inventories = process_in_transit_rows
    	when ImportRequest::IMPORT_FOR[:in_transit]
    		imported_row_count, import_errors, all_row_imported, inventories = process_oh_hold_rows
    	end

      if inventories.size > 0
        bulk_import = Inventory.import inventories
        
        if bulk_import.failed_instances.size > 0
          all_row_imported = false
        else
          imported_row_count +=bulk_import.ids.count
        end
      end

      if all_row_imported
        @import_request.update_attributes(message: "Successfully imported #{imported_row_count} inventories.", state: 'completed', error_message: import_errors.join(" | "))
      else
        @import_request.update_attributes(message: "Successfully imported #{imported_row_count} inventories. Import failed for #{import_errors.count} inventories.",
                                          errors_messages: import_errors.join(" | "), state: 'completed' )
      end

    rescue Roo::HeaderRowNotFoundError
      @import_request.update(message: exception_message , state: 'failed' )
    end
	end

	def exception_message
  	case @import_request.import_for
  	when ImportRequest::IMPORT_FOR[:in_transit]
  		"The given sheet is not proper. Your sheet must have columns with header: ITEM NUMBER,	ORG NUMBER,	QUANTITY,	STATUS,	LOT,	LAST SHIP DATE"
  	when ImportRequest::IMPORT_FOR[:on_hand]
  		"The given sheet is not proper. Your sheet must have columns with header: ITEM NUMBER,	ORG NUMBER,	QUANTITY,	STATUS,	DUE DATE"
  	end
	end

	def process_in_transit_rows
		imported_row_count = 0
		import_errors = []
		inventories = []
		all_row_imported = true

    rows.each_with_index(item_number: 'ITEM NUMBER', org_number: 'ORG NUMBER', quantity: 'QUANTITY', status: 'STATUS', lot: 'LOT', last_ship_date: 'LAST SHIP DATE') do |row, index|
      next if index == 0

      inventory = Inventory.find_by( item_number: row[:item_number] )
      if inventory
      	if inventory.update_attributes( org_number: row[:org_number],
      														     quantity: row[:quantity],
      														     status: row[:status],
      														     lot: row[:lot],
      														     last_ship_date: row[:last_ship_date])
      		imported_row_count +=1
      	else
      		all_row_imported = false
      		import_errors << inventory.errors.full_messages.join(", ")
      	end
      else
      	inventories << Inventory.new( item_number: row[:item_number],
      														 org_number: row[:org_number],
      														 quantity: row[:quantity],
      														 status: row[:status],
      														 lot: row[:lot],
      														 last_ship_date: row[:last_ship_date],
      														 inventory_type:  Inventory::TYPE[:in_transit])
      end

    end
    return imported_row_count, import_errors, all_row_imported, inventories 
	end

	def process_oh_hold_rows
		imported_row_count = 0
		import_errors = []
		inventories = []
		all_row_imported = true

    rows.each_with_index(item_number: 'ITEM NUMBER', org_number: 'ORG NUMBER', quantity: 'QUANTITY', status: 'STATUS', due_date: 'DUE DATE') do |row, index|
      next if index == 0

      inventory = Inventory.find_by( item_number: row[:item_number] )
      if inventory
      	if inventory.update_attributes( org_number: row[:org_number],
      														     quantity: row[:quantity],
      														     status: row[:status],
      														     due_date: row[:due_date])
      		imported_row_count +=1
      	else
      		all_row_imported = false
      		import_errors << inventory.errors.full_messages.join(", ")
      	end
      else
      	inventories << Inventory.new( item_number: row[:item_number],
      														 org_number: row[:org_number],
      														 quantity: row[:quantity],
      														 status: row[:status],
      														 due_date: row[:due_date],
      														 inventory_type:  Inventory::TYPE[:on_hold])
      end
    end
    return imported_row_count, import_errors, all_row_imported, inventories 
	end
end
