class CreatePlanService
  def call
    p0 = Plan.where(name: 'member').first_or_initialize do |p|
      p.amount = 0
      p.interval = 'month'
      p.stripe_id = 'member'
    end
    p0.save!(:validate => false)
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
