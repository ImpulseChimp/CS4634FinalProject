class UserMailer < ActionMailer::Base
  default from: 'community@buildmaven.com'

  # Email for user signup with authentication
  # request embedded within
  def sign_up_email(user)
    mail( :to => user.email.email_address,
          :subject => 'Verify BuildMaven e-mail')
  end

end
