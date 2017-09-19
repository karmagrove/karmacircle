class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  belongs_to :donation_charge
  has_many :ticket_purchases
  after_save :update_pike13_with_purchase
  ## 
  
  def get_buyer_pike13_id_or_create
  	 response = `curl "https://cryozonesm.pike13.com/api/v2/desk/people/search?q=#{self.buyer_email}" \
  -H "Authorization: Bearer #{self.product.user.pike13token}"`
  	 # Rails.logger.info "https://cryozonesm.pike13.com/api/v2/desk/people/search?q=#{self.buyer_email} Authorization: Bearer #{self.product.user.pike13token}"
  	 user_id = JSON.parse(response)
  	 Rails.logger.info user_id
  	 return user_id['results'][0]['person']['id']
  end

  def update_pike13_with_purchase
  	id = get_buyer_pike13_id_or_create
  	Rails.logger.info id
  # curl -XPOST https://mybiz.pike13.com/api/v2/desk/pack_products/1/packs \
  # -H "Authorization: Bearer XXXXXXXXXXXXXXX" \
  # -H "Content-Type: application/json" \
  # -d '{"pack": {"person_ids": [1]}}'

     # FUNCTIONAL!!
     response = `curl -XPOST "https://cryozonesm.pike13.com/api/v2/desk/pack_products/#{self.product.pike13productid}/packs" \
     -H "Authorization: Bearer #{self.product.user.pike13token}" \
     -H "Content-Type: application/json" \
     -d '{"pack": {"person_ids": ["#{id}"]}}'`
     Rails.logger.info response
    # 301846
  end


  def verify
#   	 curl https://cryozonesm.pike13.com/api/v2/desk/pack_products/301846 \
#   -H "Authorization: Bearer #{u.pike13token}"

#  curl https://cryozonesm.pike13.com/api/v2/desk/pack_products/301823 \
#   -H "Authorization: Bearer #{u.pike13token}"


# curl https://cryozonesm.pike13.com/api/v2/desk/pack_products/358872 \
#   -H "Authorization: Bearer #{u.pike13token}"

  end
end
