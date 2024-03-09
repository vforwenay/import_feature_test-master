class ImportsController < ApplicationController
	
	def index
		@imports = ImportRequest.all
	end

	def import_product
		@request = ImportRequest.new
	end

	def import_in_transit
		@request = ImportRequest.new
	end

	def import_on_hand
		@request = ImportRequest.new
	end

	def import
		@request = ImportRequest.new(import_request_params)
		if @request.save
			redirect_to imports_path
		else
			render :action => params[:request_from]
		end
	end

	private

	def import_request_params
		params.require(:import_request).permit(:import_file, :import_for, :extract_time)
	end
end
