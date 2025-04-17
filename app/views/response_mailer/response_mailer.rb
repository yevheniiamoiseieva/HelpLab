
class ResponseMailer < ApplicationMailer
  def notify_request_owner(response)
    @response = response
    mail(to: response.request.user.email, subject: "Вам надійшов новий відгук на запит")
  end
end
