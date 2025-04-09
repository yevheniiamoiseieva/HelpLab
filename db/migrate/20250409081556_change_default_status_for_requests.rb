class ChangeDefaultStatusForRequests < ActiveRecord::Migration[7.0]
  def change
    change_column_default :requests, :status, "очікує волонтера"
  end
end
