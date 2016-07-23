class Charity < ActiveRecord::Base
	enum status: [:suggested, :claimed, :approved, :approved_not_5013c]
	has_many :charity_users
	has_many :donation_charges
	has_many :donations

	after_initialize :set_default_status, :if => :new_record?
	#scope :

	def charity_admin 
	  self.charity_users.where(role: 1).each do |charity_user|
	    return charity_user.charity
	  end
	end
	def set_default_status
    self.status ||= :suggested
    end

    def self.approved_charities
    	Charity.where(:status => "approved")
    end

    def donate
    	# self.user_id
           Stripe::Transfer.create(
           :amount => 100000,
           :destination => '',
            :currency => 'usd')
    end
end
