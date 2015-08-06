class CreateCharityService
  def call
    charity = Charity.find_or_create_by!(name: "Genesis Women's Shelter") do |charity|
        charity.name = "Genesis Women's Shelter"
        charity.description = "Genesis offers shelter to women who report violence to the police, run a second hand store for recycling clothing, and other Women's services."
        charity.url = "www.genesiswomensshelter.org"
        charity.stripe_id = "example_stripe_id_to_pay_them"
        charity.email = "uncertain@genesis.org"
        charity.city = "Dallas"
        charity.state = "TX"
        charity.status = "suggested"
    end

    charity = Charity.find_or_create_by!(name: "Mosaic Services") do |charity|
        charity.name = "Mosaic Services"
        charity.description = "Mosaic services offers shelter to women and children in Dallas"
        charity.url = "www.mosaicservices.org"
        charity.stripe_id = "example_stripe_id_to_pay_them"
        charity.email = "uncertain@mosaicservices.org"
        charity.city = "Dallas"
        charity.state = "TX"
        charity.status = "suggested"

    end

    charity = Charity.find_or_create_by!(name: "Grey Bears") do |charity|
        charity.name = "Grey Bears"
        charity.description = "feeding elderly in Santa Cruz County, computer literacy, yoga, recycling center"
        charity.url = "www.greybears.org"
        charity.stripe_id = "example_stripe_id_to_pay_them"
        charity.email = "uncertain@greybears.org"
        charity.city = "Santa Cruz"
        charity.state = "CA"
        charity.status = "suggested"
    end

    charity = Charity.find_or_create_by!(name: "Elephants and Bees") do |charity|
        charity.name = "Elephants and Bees"
        charity.description = "Giving beehive fences to impoverished farmers to create honey crop and protect elephants."
        charity.url = "www.elephantsandbeess.org"
        charity.stripe_id = "rp_6kOtLdFPSggt1D"
        charity.email = "uncertain@elephantsandbees.org"
        charity.city = "Africa"
        charity.state = "Africa"
        charity.status = "approved"
    end

    charity = Charity.find_or_create_by!(name: "Wounded Warriors") do |charity|
        charity.name = "Wounded Warriors"
        charity.description = "Soldiers projects."
        charity.url = "www.woundedwarriors.org"
        charity.stripe_id = "example_stripe_id_to_pay_them"
        charity.email = "uncertain@woundedwarriors.org"
        charity.city = "allover"
        charity.state = "All of them"
        charity.status = "suggested"
    end
  end
end
