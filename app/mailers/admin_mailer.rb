class AdminMailer < ApplicationMailer
  def invitation_email(invitation)
    @invitation = invitation
    @url = accept_api_v1_invitation_url(token: @invitation.token)
    
    mail(
      to: @invitation.email,
      subject: 'Invitation to join Admin Panel'
    )
  end
end 