class AddBodyToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :body, :text
  end
end
