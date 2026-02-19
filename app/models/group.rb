class Group < ActiveRecord::Base
  has_many                :requirements
  belongs_to              :employee

  has_many :sub_groups,
           :class_name => "Group",
           :foreign_key => "parent_id"
  belongs_to :parent,
             :class_name => "Group",
             :foreign_key => "parent_id"

  def practice_head
    self.employee
  end

  def ta_head
    ta = nil
    group = self
    while !ta && group
      ta = Employee.where(group: group).where('employee_type LIKE ?', '%TA_HEAD%').first
      group = group.parent
    end
    if !ta
      ta = Employee.where(is_admin: true).first
    end
    ta
  end

  def descendants
    groups = []
    sub_groups.each do |g|
      groups << g
      groups += g.descendants
    end
    groups
  end

  def Group.get_group_array_for_select
    Group.all.map{|g| [g.name, g.id]}
  end


  validates_presence_of   :name
  validates_presence_of   :employee_id
  validates_uniqueness_of :name
end
