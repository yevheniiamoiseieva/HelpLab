class Request < ApplicationRecord
  belongs_to :user
  has_many :responses, dependent: :destroy

  CATEGORIES = ['Продукти', 'Одяг', 'Техніка', 'Мебелі']
  STATUSES = ['Потрібна допомога', 'У процесі', 'Завершено']

  validates :title, :description, :category, :location, :status, presence: true
end
