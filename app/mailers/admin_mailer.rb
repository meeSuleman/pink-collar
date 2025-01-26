class AdminMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: "admin_mailer"
  default from: "Pink Collar Team <2016n0575@gmail.com>"

  def reset_password_instructions(record, token, opts = {})
    @token = token
    @admin = record
    @reset_url = edit_api_v1_admin_password_url(reset_password_token: @token)

    mail(
      to: record.email,
      subject: "Reset Password Instructions",
      template_path: "admin_mailer",
      template_name: "reset_password_instructions"
    )
  end

  def invitation_email(invitation)
    @invitation = invitation
    @url = accept_api_v1_invitation_url(token: @invitation.token)

    mail(
      to: @invitation.email,
      subject: "Invitation to join Admin Panel"
    )
  end
end
