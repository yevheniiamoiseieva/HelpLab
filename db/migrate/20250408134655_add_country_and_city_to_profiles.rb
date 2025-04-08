class AddCountryAndCityToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :country, :string
    add_column :profiles, :city, :string
  end
end
