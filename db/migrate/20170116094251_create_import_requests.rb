class CreateImportRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :import_requests do |t|
      t.string :state
      t.text :message
      t.datetime :extract_time
      t.string :import_file
      t.string :import_for

      t.timestamps
    end
  end
end
