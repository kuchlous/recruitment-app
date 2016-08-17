class AddCurrentCompanyToResumes < ActiveRecord::Migration
  def self.up
    add_column     :resumes, :current_company, :string
  end

  def self.down
    remove_column  :resumes, :current_company
  end
end
