class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end

    add_column :questions, :votes_count, :integer

    add_column :answers, :votes_count, :integer
  end
end
