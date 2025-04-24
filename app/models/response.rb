class Response < ApplicationRecord
  belongs_to :user
  belongs_to :request
  has_many :messages

  STATUSES = ['Прийнято', 'Відхилено', 'Очікує']

  # Добавляем валидацию присутствия
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: 'Очікує') }
end
