class UserMailer < ActionMailer::Base
  default :from => "do-not-reply@karmagrove.com"

  def expire_email(user)
    mail(:to => user.email, :subject => "Subscription Cancelled")
  end
end
