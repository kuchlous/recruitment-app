class AddCurrentCompanyToResumes < ActiveRecord::Migration[5.2]
  def self.up
    add_column     :resumes, :current_company, :string
  end

  def self.down
    remove_column  :resumes, :current_company
  end
end
