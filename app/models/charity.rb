class Charity < ActiveRecord::Base
	enum status: [:suggested, :claimed, :approved]
	has_many :charity_users

	after_initialize :set_default_status, :if => :new_record?

	def set_default_status
    self.status ||= :suggested
    end
end
