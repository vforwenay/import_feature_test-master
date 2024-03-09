class AddErrorsToImportRequests < ActiveRecord::Migration[5.0]
  def change
  	add_column :import_requests, :error_message, :text 
  end
end
