class Request < ApplicationRecord
  belongs_to :user
  has_many :responses, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :volunteers, through: :responses, source: :user

  CATEGORIES = ['Продукти', 'Одяг', 'Техніка', 'Мебелі']
  STATUSES = ['Потрібна допомога', 'У процесі', 'Завершено']

  scope :active, -> { where.not(status: 'Завершено') }
  scope :with_responses, -> { joins(:responses).distinct }
  scope :recently_completed, -> { where(status: 'Завершено').order(updated_at: :desc).limit(3) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_status, ->(status) { where(status: status) }
  scope :search, ->(query) { where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") }
  validates :title, :description, :category, :location, :status, presence: true

  def responses_count
    responses.count
  end
end