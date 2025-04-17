# app/helpers/profiles_helper.rb
module ProfilesHelper
  def avatar_url_for(profile)
    if profile.avatar.attached?
      profile.avatar.variant(resize_to_fill: [ 200, 200 ], saver: { quality: 80 })
    else
      asset_path("default-avatar.png")
    end
  end
end
