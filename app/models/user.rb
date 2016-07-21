class User < ActiveRecord::Base

  enum role: [:user, :admin, :customer, :charity_admin, :partner, :patron, :subscriber, :member]
  @@mapped_roles = roles

  after_initialize :set_default_role, :if => :new_record?
  after_initialize :set_default_plan, :if => :new_record?
  after_initialize :set_transaction_cost, :if => :new_record?
  after_create :sign_up_for_mailing_list
  # devise :omniauthable

  belongs_to :plan
  # validates_associated :plan, :unless 
  has_many :charity_users
  has_many :donation_charges
  has_many :user_invites

  def charity
    if self.role == "charity_admin" then
      self.charity_users.where(role: 1).each do |user|
        return user
      end
    else
      return false
    end
  end

  def total_donations
    @amount = 0
    Donation.where(:user_id => self.id).each do |donation|
      @amount += donation.donation_amount
    end
    @amount
  end

  def total_pledged_donations
    @amount = 0
    DonationCharge.where(:user_id => self.id).each do | dc |
      @amount += dc.donation_amount
    end
    @amount
  end

  def set_transaction_cost
    self.transaction_cost = 100
    self.donation_rate = 1
    if self.plan and self.plan.name == "Partner" then
      self.transaction_cost = 10
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook,:stripe_connect]

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

  def self.find_or_create_by_facebook_id(facebook_id)
    if User.exists?(:facebook_id =>facebook_id)
      user = User.where(:facebook_id =>facebook_id)
    else
      user = User.new(:facebook_id => facebook_id)
      # user.plan=7
      user.save
    end
    return user
  end

  def calculate_application_fee(amount)
    @amount = amount
    application_fee = self.transaction_cost
    donation_amount = (@amount.to_i* self.donation_rate/100.to_f).to_i
    Rails.logger.info("current_user.donation_rate: ")
    Rails.logger.info("donation_amount #{donation_amount}")
    application_fee = application_fee + donation_amount
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

  class << self # Class methods ============

    def return_(role="users")
      singular_role= role.pluralize.singularize
      where(role: @@mapped_roles[singular_role])
    end

  end # ======================================

  private

  def set_default_role
    self.role ||= :user
  end

  def set_default_plan
    self.plan ||= Plan.last
  end

end
