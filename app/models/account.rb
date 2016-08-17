class Account < ActiveRecord::Base
  has_and_belongs_to_many :requirements

  def Account.get_account_array_for_select
    account_array = []
    all_accounts  = Account.all
    all_accounts.each do |acc|
      if (acc.status == "ACTIVE")
        account_array.push([acc.name, acc.id])
      end
    end
    account_array
  end
end
