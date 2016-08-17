class Uniqid < ActiveRecord::Base
  has_one :requirement
  has_one :resume

  validates_uniqueness_of :name

  def self.generate_unique_id(name, object)
    # merge multiple spaces into '1' and remove spaces at the end
    goodname = name.squeeze(" ").strip.downcase
    # Replace white-space with '_'
    goodname = goodname.gsub(/\s+/, '_')
    # Remove non-word characters
    goodname = goodname.gsub(/[^\w]/, '')
    unique_id = goodname
    suffix = 0
    while (entity = self.find_by_name(unique_id))
      unique_id = goodname + "_" + suffix.to_s
      suffix += 1
    end
    if object.is_a?(Resume)
      uniqid = Uniqid.new(:name => unique_id, :resume => object, :requirement => NIL)
    end
    return uniqid
  end
end
