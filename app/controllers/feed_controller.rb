class FeedController < ApplicationController
  def index
    if current_user&.role == "volunteer"
      @requests = Request.where.not(user_id: current_user.id).order(created_at: :desc)
    else
      @contacts = ["https://dopomoga.gov.ua", "https://pryhulky.com", "https://help.gov.ua"]
      @news = [
        "З 1 травня змінилась адресна допомога ВПО",
        "Нові пункти обігріву у Харкові",
        "Пільги для оренди житла для переселенців"
      ]
    end
  end
end
