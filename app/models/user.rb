class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_one :profile, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reviews, foreign_key: :reviewed_user_id, dependent: :destroy
  has_many :authored_reviews, class_name: "Review", foreign_key: :author_id

  # Scopes
  scope :volunteers, -> { where(role: "volunteer") }
  scope :regular_users, -> { where(role: "regular") }

  ROLES = {
    "Волонтер" => "volunteer",
    "Потребувач допомоги" => "regular"
  }.freeze

  validates :role, presence: true, inclusion: { in: ROLES.values }

  after_create :create_profile

  def average_rating
    reviews.average(:rating).to_f.round(1) || 0
  end

  def volunteer?
    role == "volunteer"
  end

  def regular?
    role == "regular"
  end

  private

  def create_profile
    build_profile(
      first_name: email.split("@").first,
      city: "Не вказано",
      country: "Не вказано"
    ).save
  rescue => e
    Rails.logger.error "Ошибка при создании профиля: #{e.message}"
  end
end
