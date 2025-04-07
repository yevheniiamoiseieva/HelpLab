# app/models/profile.rb
class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [200, 200]
  end

  validates :first_name, presence: true
  validate :validate_avatar

  private

  def validate_avatar
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/png image/jpeg])
      errors.add(:avatar, 'must be a PNG or JPEG image')
    end

    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, 'size should be less than 5MB')
    end
  end
end