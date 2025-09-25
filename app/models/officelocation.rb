class Officelocation < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  def full_address
    [address, city, state, pincode].compact.reject(&:blank?).join(', ')
  end

  def display_name
    "#{name} - #{city}, #{state}"
  end
end
