class Response < ApplicationRecord
  belongs_to :user
  belongs_to :request

  STATUSES = [ "Прийнято", "Відхилено" ]

  validates :status, presence: true
end
