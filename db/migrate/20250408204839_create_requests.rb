class CreateRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :category
      t.string :location
      t.string :status, default: 'Потрібна допомога'

      t.timestamps
    end
  end
end
