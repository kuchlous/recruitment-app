class Message < ActiveRecord::Base
  belongs_to            :resume
  belongs_to            :sent_to,
                        :class_name  => "Employee",
                        :foreign_key => "sent_to"
  belongs_to            :sent_by,
                        :class_name  => "Employee",
                        :foreign_key => "sent_by"

  def find_all_messages_of_parent_message
    msg_arr    = []
    parent_msg = self.reply_to
    msg_arr    << self
    unless parent_msg == self.id
      msg_arr << Message.find(parent_msg)
      parent_msg = Message.find(parent_msg).reply_to
    end
    msg_arr << Message.find(parent_msg)
    msg_arr
  end

  def deleted
    if self.is_deleted
      return true
    else
      return false
    end
  end

  def replied
    if self.is_replied
      return true
    else
      return false
    end
  end

  def read
    if self.is_read
      return true
    else
      return false
    end
  end
end
