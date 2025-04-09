class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :reviewed_user, null: false, foreign_key: { to_table: :users }
      t.integer :rating, null: false
      t.text :comment, null: false

      t.timestamps
    end

    add_index :reviews, [:author_id, :reviewed_user_id], unique: true
  end
end
