class AddCtypeToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :ctype, :string
  end
end 