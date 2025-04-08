# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,   :confirmable

  has_one :profile, dependent: :destroy
  after_create :create_profile

  private

  def create_profile
    create_profile!(first_name: email.split('@').first)
  end
end