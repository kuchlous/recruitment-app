class AddPhRatingToResumes < ActiveRecord::Migration[5.2]
  def change
    add_column :resumes, :practice_head_rating, :string
  end
end
