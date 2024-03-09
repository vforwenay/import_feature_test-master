class ImportRequest < ApplicationRecord
  default_scope { order(created_at: :desc) }
  
  mount_uploader :import_file, ImportFileUploader
  validates_presence_of :import_file

  IMPORT_FOR = { 
                 product: 'Product', 
                 in_transit: 'InTransitInventory', 
                 on_hand: 'OnHandInventory'
               }

  after_create :set_background_job

  private

  def set_background_job
		self.update(state: "inprocess")
		unless self.extract_time.present?
			ImportRequestJob.set(wait_until: Time.now ).perform_later(self.id)
  	else
  		ImportRequestJob.set(wait_until: self.extract_time ).perform_later(self.id)
  	end
  end
end
