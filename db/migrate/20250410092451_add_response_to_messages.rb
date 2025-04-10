class AddResponseToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :response, foreign_key: true, null: true

  end
end
