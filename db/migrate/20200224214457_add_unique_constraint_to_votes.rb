class AddUniqueConstraintToVotes < ActiveRecord::Migration[6.0]
  def change
    add_index :votes, %i[user_id votable_type votable_id], unique: true
  end
end
