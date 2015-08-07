class User < ActiveRecord::Base
  enum role: [:user, :admin, :customer, :charity_admin, :partner, :patron, :subscriber]
  after_initialize :set_default_role, :if => :new_record?
  after_initialize :set_default_plan, :if => :new_record?
  after_initialize :set_transaction_cost, :if => :new_record?
  after_create :sign_up_for_mailing_list
  # devise :omniauthable

  belongs_to :plan
  validates_associated :plan 
  has_many :charity_users
  has_many :donation_charges

  def set_default_role
    self.role ||= :user
  end

  def set_default_plan
    self.plan ||= Plan.last
  end

  def set_transaction_cost
    self.transaction_cost = 100
    self.donation_rate = 1
    if self.plan.name == "Partner" then
      self.transaction_cost = 10
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def sign_up_for_mailing_list
    MailingListSignupJob.perform_later(self)
  end

  def has_plan?
    if self.plan
      return true
    else
      return false
    end
  end

  def subscribe
    mailchimp = Gibbon::API.new(Rails.application.secrets.mailchimp_api_key)
    result = mailchimp.lists.subscribe({
      :id => Rails.application.secrets.mailchimp_list_id,
      :email => {:email => self.email},
      :double_optin => false,
      :update_existing => true,
      :send_welcome => true
    })
    Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
  end

end
