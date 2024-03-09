require 'import_support'

class ImportProduct
	include ImportSupport

	def initialize(import_request_id)
		@import_request = ImportRequest.find(import_request_id)
	end

	def rows
		get_rows(@import_request.id)
	end

	def execute
    status = true
    all_row_imported = true
    import_errors = []
    products = []
    imported_row_count = 0

    begin
      rows.each_with_index(item_number: 'ITEM NUMBER', item_description: 'ITEM DESCRIPTION', item_status: 'ITEM STATUS', category: 'CATEGORY', sale_type: 'SALES TYPE') do |row, index|
        next if index == 0

        product = Product.find_by( item_number: row[:item_number] )

        if product
        	if product.update_attributes(item_description: row[:item_description],
        														item_status: row[:item_status],
        														category: row[:category],
        														sale_type: row[:sale_type])
        		imported_row_count +=1
        	else
            all_row_imported = false
        		import_errors << product.errors.full_messages.join(", ")
        	end
        else
        	products << Product.new(	item_number: row[:item_number],
      														item_description: row[:item_description],
      														item_status: row[:item_status],
      														category: row[:category],
      														sale_type: row[:sale_type] )
        end
      end

      if products.size > 0
        bulk_import = Product.import products
        
        if bulk_import.failed_instances.size > 0
          all_row_imported = false
        else
          imported_row_count +=bulk_import.ids.count
        end
      end

      if all_row_imported
        @import_request.update_attributes(message: "Successfully imported #{imported_row_count} products.", state: 'completed', error_message: import_errors.join(" | "))
      else
        @import_request.update_attributes(message: "Successfully imported #{imported_row_count} products. Import failed for #{import_errors.count} products.",
                                          errors_messages: import_errors.join(" | "), state: 'completed' )
      end

    rescue Roo::HeaderRowNotFoundError
      @import_request.update(message: "The given sheet is not proper. Your sheet must have columns with header: ITEM NUMBER,	ITEM DESCRIPTION,	ITEM STATUS,	CATEGORY,	SALES TYPE", state: 'failed' )
    end
	end
end