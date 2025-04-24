require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    it "is valid with all required attributes" do
      profile = build(:profile, user: user)
      expect(profile).to be_valid
    end

    it "is invalid without a first_name" do
      profile = build(:profile, user: user, first_name: nil)
      expect(profile).not_to be_valid
      expect(profile.errors[:first_name]).to include("can't be blank")
    end

    it "is invalid without a country" do
      profile = build(:profile, user: user, country: nil)
      expect(profile).not_to be_valid
      expect(profile.errors[:country]).to include("can't be blank")
    end

    it "is invalid without a city" do
      profile = build(:profile, user: user, city: nil)
      expect(profile).not_to be_valid
      expect(profile.errors[:city]).to include("can't be blank")
    end
  end

  describe "avatar validations" do
    it "is invalid with a non-image attachment" do
      profile = build(:profile, user: user)
      profile.avatar.attach(io: StringIO.new("text content"), filename: "file.txt", content_type: "text/plain")
      profile.valid?
      expect(profile.errors[:avatar]).to include("must be a PNG or JPEG image")
    end

    it "is invalid if the avatar is larger than 5MB" do
      profile = build(:profile, user: user)
      big_file = Tempfile.new
      big_file.write("0" * 5.1.megabytes)
      big_file.rewind

      profile.avatar.attach(io: big_file, filename: "big.png", content_type: "image/png")
      profile.valid?
      expect(profile.errors[:avatar]).to include("size should be less than 5MB")

      big_file.close
      big_file.unlink
    end

    it "is valid with a proper image under 5MB" do
      profile = build(:profile, user: user)
      image = File.open(Rails.root.join("spec/fixtures/files/avatar.jpg"))
      profile.avatar.attach(io: image, filename: "avatar.jpg", content_type: "image/jpg")
      expect(profile).to be_valid
    end
  end

  describe "#full_name" do
    it "returns full name with both first and last name" do
      profile = build(:profile, user: user, first_name: "John", last_name: "Doe")
      expect(profile.full_name).to eq("John Doe")
    end

    it "returns only first name if last name is nil" do
      profile = build(:profile, user: user, first_name: "John", last_name: nil)
      expect(profile.full_name).to eq("John")
    end
  end
end
