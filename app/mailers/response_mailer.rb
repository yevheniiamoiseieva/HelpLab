class ResponseMailer < ApplicationMailer
  def notify_request_owner(response)
    @response = response
    @request = response.request
    @user = @request.user

    mail(to: @user.email, subject: "Новий відгук на ваш запит")
  end
end
