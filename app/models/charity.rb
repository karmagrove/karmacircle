class Charity < ActiveRecord::Base
	enum status: [:suggested, :claimed, :approved, :approved_not_5013c]
	has_many :charity_users
	has_many :donation_charges
	has_many :donations

	after_initialize :set_default_status, :if => :new_record?
	# scope :


    def self.active_list
      response = Charity.actives.map {|p| 
          OpenStruct.new({:charity_id => p.id,:charity_name => p.name, :charity_description => p.description, :charity_url => p.url} )
       }
      response

    end

    def self.actives
        return Charity.where(:status => "approved")
    end

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

    def new_charity_admin(user_id)
    	#CharityUser.create(:charity_id => self.id, :user_id => user_id, )
    end

    def donate
    	# self.user_id
           Stripe::Transfer.create(
           :amount => 100000,
           :destination => '',
            :currency => 'usd')
    end
end
