require 'import_product'
class  ImportRequestJob < ApplicationJob

  queue_as :default

  def perform(import_request_id)  
    ir = ImportRequest.find(import_request_id)

    case ir.import_for
    when ImportRequest::IMPORT_FOR[:product]
      ip = ImportProduct.new(import_request_id)
      ip.execute
    when ImportRequest::IMPORT_FOR[:in_transit], ImportRequest::IMPORT_FOR[:on_hand]
      ii = ImportInventory.new(import_request_id)
      ii.execute
    end
  end
end