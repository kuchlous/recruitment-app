class AddInternationalPhoneToResumes < ActiveRecord::Migration[7.0]
  def change
    add_column :resumes, :international_phone, :string
  end
end
