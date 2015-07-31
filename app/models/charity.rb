class Charity < ActiveRecord::Base
	enum status: [:suggested, :claimed, :approved]
	has_many :charity_users
	has_many :donation_charges
	has_many :donations

	after_initialize :set_default_status, :if => :new_record?

	def set_default_status
    self.status ||= :suggested
    end
end
