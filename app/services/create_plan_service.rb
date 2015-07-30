class CreatePlanService
  def call
    p1 = Plan.where(name: 'Partner').first_or_initialize do |p|
      p.amount = 0
      p.interval = 'month'
      p.stripe_id = 'partner'
    end
    p1.save!(:validate => false)
    
    p2 = Plan.where(name: 'Patron').first_or_initialize do |p|
      p.amount = 0
      p.interval = 'month'
      p.stripe_id = 'patron'
    end
    p2.save!(:validate => false)

    p3 = Plan.where(name: 'Charity').first_or_initialize do |p|
      p.amount = 0
      p.interval = 'month'
      p.stripe_id = 'charity'
    end
    p3.save!(:validate => false)
  end
end
