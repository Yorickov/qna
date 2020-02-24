class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end

    add_column :questions, :rating, :integer, default: 0

    add_column :answers, :rating, :integer,  default: 0
  end
end
