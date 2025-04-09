class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # Ассоциации
  has_one :profile, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Отзывы
  has_many :reviews, foreign_key: :reviewed_user_id, dependent: :destroy               # отзывы о пользователе
  has_many :authored_reviews, class_name: "Review", foreign_key: :author_id           # отзывы от пользователя

  # Средний рейтинг
  def average_rating
    reviews.average(:rating) || 0
  end

  # Доступные роли
  ROLES = {
    "Волонтер" => "volunteer",
    "Потребувач допомоги" => "regular"
  }.freeze

  # Валидации
  validates :role, presence: true

  # Коллбек: создать профиль после регистрации
  after_create :create_profile

  private

  def create_profile
    create_profile!(first_name: email.split('@').first)
  end
end
