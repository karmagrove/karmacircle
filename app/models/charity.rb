class Charity < ActiveRecord::Base
	enum status: [:suggested, :claimed, :approved]

	after_initialize :set_default_status, :if => :new_record?

	def set_default_status
    self.status ||= :suggested
    end
end
