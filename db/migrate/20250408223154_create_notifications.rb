# db/migrate/xxx_create_notifications.rb
class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message
      t.boolean :read, default: false
      t.references :request, foreign_key: true

      t.timestamps
    end
  end
end
