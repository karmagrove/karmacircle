class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  belongs_to :donation_charge
  has_many :ticket_purchases
  # moves into method
  # after_save :update_pike13_with_purchase
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
     if self.product.user.email == "santamonica@thecryozone.com"
       cmd = 'curl -XPOST https://' + self.product.user.pike13subdomain + '.pike13.com/api/v2/desk/people \
               -H "Authorization: Bearer ' + self.product.user.pike13token + '" \
               -H "Content-Type: application/json" \
               -d \'{"person":{"first_name": "' + first_name + '", "last_name" : "' + last_name + '", "email": "' + self.buyer_email + '", "custom_fields": [{"id":110812,"value":"KarmaGrove"}]}}\''
     elsif self.product.user.email == "uptown@thecryozone.com"
       cmd = 'curl -XPOST https://' + self.product.user.pike13subdomain + '.pike13.com/api/v2/desk/people \
               -H "Authorization: Bearer ' + self.product.user.pike13token + '" \
               -H "Content-Type: application/json" \
               -d \'{"person":{"first_name": "' + first_name + '", "last_name" : "' + last_name + '", "email": "' + self.buyer_email + '", "custom_fields": [{"id":110790,"value":"KarmaGrove"}]}}\''
     else
         cmd = 'curl -XPOST https://' + self.product.user.pike13subdomain + '.pike13.com/api/v2/desk/people \
               -H "Authorization: Bearer ' + self.product.user.pike13token + '" \
               -H "Content-Type: application/json" \
               -d \'{"person":{"first_name": "' + first_name + '", "last_name" : "' + last_name + '", "email": "' + self.buyer_email + '"}}\''
               
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
     pike13_id = false
     if (user_id['results'].length > 0) && (user_id['results'][0]['person']['email'].downcase == self.buyer_email.downcase)
  	   pike13_id = user_id['results'][0]['person']['id'] 
     else 
       user_id['results'].each do |person|
          if (person['person']['email'].downcase == self.buyer_email.downcase)
            pike13_id = person['person']['id'] 
          end  
        end 
     end
     if pike13_id 
       return pike13_id
     else 
       return self.create_user
     end
  end

  

  def update_pike13_with_purchase(tries = 0)

    begin 
  	  if self.product.pike13productid
       	 id = get_buyer_pike13_id_or_create
       	 Rails.logger.info "attempting post for purchase with id #{id}" 
         # curl -XPOST https://mybiz.pike13.com/api/v2/desk/pack_products/1/packs \
         # -H "Authorization: Bearer XXXXXXXXXXXXXXX" \
         # -H "Content-Type: application/json" \
         # -d '{"pack": {"person_ids": [1]}}'
     
          # FUNCTIONAL!!
          response = `curl -XPOST "https://#{self.product.user.pike13subdomain}.pike13.com/api/v2/desk/pack_products/#{self.product.pike13productid}/packs" \
          -H "Authorization: Bearer #{self.product.user.pike13token}" \
          -H "Content-Type: application/json" \
          -d '{"pack": {"person_ids": ["#{id}"]}}'`

          unless response and response['packs']
            self.delay(run_at: 5.minutes.from_now).update_pike13_with_purchase(tries)
            # NEED TO EMAIL MYSELF HERE. 
          end

          Rails.logger.info "response from post of product #{response.inspect}"
      end
      # 301846
  
    rescue Exception => e
      Rails.logger.info("exception #{e.message}")
      # NEED TO EMAIL MYSELF HERE. 
      tries = tries + 1 
      Rails.logger.info("tries: #{tries}")
      if tries > 5
        return false
      else
        # Notifier.delay(run_at: 5.minutes.from_now)
        #  RECENTLY ADDS 5 minutes from now trying.
        self.delay(run_at: 5.minutes.from_now).update_pike13_with_purchase(tries)
      end
    end

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
