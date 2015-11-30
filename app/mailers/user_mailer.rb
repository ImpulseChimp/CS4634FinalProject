class UserMailer < ActionMailer::Base
  default from: 'community@buildmaven.com'

  # Email for user signup with authentication
  # request embedded within
  def sign_up_email(user)
    mail( :to => user.email.email_address,
          :subject => 'Verify BuildMaven e-mail')
  end

  def trucker_invite_email(comp_name, truck_email, truck_pass)

    @company_name = comp_name
    @trucker_email = truck_email
    @trucker_password = truck_pass

    mail( :to => truck_email,
          :subject => 'Invitation to RigReviews')
  end

end
