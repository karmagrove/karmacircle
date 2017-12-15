class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  belongs_to :donation_charge
  has_many :ticket_purchases
  after_save :update_pike13_with_purchase
  ## 
  
  def create_user
    if self.buyer_name && self.buyer_name.split(' ')[1]
      first_name = self.buyer_name.split(' ')[0]
      last_name = self.buyer_name.split(' ')[1]
    else
      first_name = self.buyer_email
      last_name = self.buyer_email
    end
     # response = `curl -XPOST https://cryozonesm.pike13.com/api/v2/desk/people \
     # -H "Authorization: Bearer #{self.product.user.pike13token}" \
     # -H "Content-Type: application/json" \
     # -d '{"person":{"first_name": "#{first_name}", "last_name": "#{last_name}": "Client", "email": "#{self.buyer_email}", "custom_fields": [{"id":110812,"value":"KarmaGrove"}]}}'`
     # Rails.logger.info ('curl -XPOST https://cryozonesm.pike13.com/api/v2/desk/people \
     #           # -H "Authorization: Bearer #{self.product.user.pike13token}" \
     #           # -H "Content-Type: application/json" \
     #           # -d \'{"person":{"first_name": "#{first_name}","last_name":"#{last_name}": "Client", "email": "#{self.buyer_email}", "custom_fields": [{"id":110812,"value":"KarmaGrove"}]}}\'') 
     
     # Rails.logger.info "RESONSE! /n \n"
     if seller.email == "santamonica@thecryozone.com"
       cmd = 'curl -XPOST https://' + self.product.user.pike13subdomain + '.pike13.com/api/v2/desk/people \
               -H "Authorization: Bearer ' + self.product.user.pike13token + '" \
               -H "Content-Type: application/json" \
               -d \'{"person":{"first_name": "' + first_name + '", "last_name" : "' + last_name + '", "email": "' + self.buyer_email + '", "custom_fields": [{"id":110812,"value":"KarmaGrove"}]}}\''
     elsif seller.email == "uptown@thecryozone.com"
       cmd = 'curl -XPOST https://' + self.product.user.pike13subdomain + '.pike13.com/api/v2/desk/people \
               -H "Authorization: Bearer ' + self.product.user.pike13token + '" \
               -H "Content-Type: application/json" \
               -d \'{"person":{"first_name": "' + first_name + '", "last_name" : "' + last_name + '", "email": "' + self.buyer_email + '", "custom_fields": [{"id":110790,"value":"KarmaGrove"}]}}\''
     else
         cmd = 'curl -XPOST https://' + self.product.user.pike13subdomain + '.pike13.com/api/v2/desk/people \
               -H "Authorization: Bearer ' + self.product.user.pike13token + '" \
               -H "Content-Type: application/json" \
               -d \'{"person":{"first_name": "' + first_name + '", "last_name" : "' + last_name + '", "email": "' + self.buyer_email + '}}\''
               
     end
     Rails.logger.info cmd
     response = %x(#{cmd})
     Rails.logger.info response
     user_id = JSON.parse(response)
     return user_id['people'][0]['id']
  end 
    
  def get_buyer_pike13_id_or_create

  	 response = `curl "https://#{self.product.user.pike13subdomain}.pike13.com/api/v2/desk/people/search?q=#{self.buyer_email}" \
  -H "Authorization: Bearer #{self.product.user.pike13token}"`
  	 # Rails.logger.info "https://cryozonesm.pike13.com/api/v2/desk/people/search?q=#{self.buyer_email} Authorization: Bearer #{self.product.user.pike13token}"
  	 Rails.logger.info response
     user_id = JSON.parse(response)
  	 Rails.logger.info user_id
     if (user_id['results'].length > 0) && (user_id['results'][0]['person']['email'] == self.buyer_email)
  	   return user_id['results'][0]['person']['id'] 
     else
       return create_user
     end
  end

  def update_pike13_with_purchase
  	if self.product.pike13productid
     	id = get_buyer_pike13_id_or_create
     	Rails.logger.info id
     # curl -XPOST https://mybiz.pike13.com/api/v2/desk/pack_products/1/packs \
     # -H "Authorization: Bearer XXXXXXXXXXXXXXX" \
     # -H "Content-Type: application/json" \
     # -d '{"pack": {"person_ids": [1]}}'
   
        # FUNCTIONAL!!
        response = `curl -XPOST "https://#{self.product.user.pike13subdomain}.pike13.com/api/v2/desk/pack_products/#{self.product.pike13productid}/packs" \
        -H "Authorization: Bearer #{self.product.user.pike13token}" \
        -H "Content-Type: application/json" \
        -d '{"pack": {"person_ids": ["#{id}"]}}'`
        Rails.logger.info response
    end
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
