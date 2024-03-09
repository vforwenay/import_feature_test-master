require 'open-uri'

module ImportSupport

	def get_rows(import_request_id)
    ir = ImportRequest.find(import_request_id)
  
    case ir.import_file.content_type
    when "application/zip"
      rows = Roo::Excelx.new(ir.import_file.path);
    when "text/comma-separated-values"
      rows = Roo::CSV.new(ir.import_file.path);
    else
      rows = Roo::Excelx.new(ir.import_file.path);
    end

    rows.default_sheet = rows.sheets[0]
    header_row = rows.row(1)
		rows
	end

end