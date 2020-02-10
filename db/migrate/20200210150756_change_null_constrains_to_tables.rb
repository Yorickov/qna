class ChangeNullConstrainsToTables < ActiveRecord::Migration[6.0]
  def change
    change_column_null :questions, :user_id, true
    change_column_null :answers, :user_id, true
    change_column_null :answers, :question_id, true
  end
end
