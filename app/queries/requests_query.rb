# app/queries/requests_query.rb
class RequestsQuery
  def initialize(relation = Request.all)
    @relation = relation.extending(Scopes)
  end

  def call(params = {})
    scoped = @relation
    scoped = scoped.by_category(params[:category]) if params[:category].present?
    scoped = scoped.by_status(params[:status]) if params[:status].present?
    scoped = scoped.search(params[:search]) if params[:search].present?
    scoped = scoped.order_by(params[:sort]) if params[:sort].present?
    scoped
  end

  module Scopes
    def by_category(category)
      where(category: category)
    end

    def by_status(status)
      where(status: status)
    end

    def search(query)
      where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
    end

    def order_by(sort_option)
      case sort_option
      when "newest" then order(created_at: :desc)
      when "oldest" then order(created_at: :asc)
      when "most_responses" then left_joins(:responses).group(:id).order("COUNT(responses.id) DESC")
      when "least_responses" then left_joins(:responses).group(:id).order("COUNT(responses.id) ASC")
      else order(created_at: :desc)
      end
    end
  end
end
