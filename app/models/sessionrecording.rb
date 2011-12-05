class Sessionrecording < ActiveRecord::Base
  establish_connection :dill_db
  set_table_name "sessionrecording"
  
  belongs_to      :usersession
  belongs_to      :student
  belongs_to      :grouptask
  has_many        :comments
        
  def downloadable?(user)
    case
    when self.task.permission && self.task.permission.isselfdownloadable && self.student == user
      return true
    when self.task.permission && self.task.permission.isgroupdownloadable && self.task.student_has_recorded_in?(user)
      return true
    when user.is_super_admin?
      return true
    when self.task.instructor == user
      return true
    else
      return false
    end
  end
  
  def student
    return Student.find(Usersession.find(self.associatedusersessionid).associatedstudentsid)
  end
  
  def task
    return Grouptask.find(Usersession.find(self.associatedusersessionid).associatedgrouptaskid)
  end
  
  def grouptask
    return Grouptask.find(Usersession.find(self.associatedusersessionid).associatedgrouptaskid)
  end
  
  def url_to_file
    return "#{SysParam.get(:HTTPURLPathToRecordedAudio)}#{self.clipfilename}"
  end
  
  def identifier
    return "rec_#{self.clipfilename.split('.')[0].gsub("-", "")}"
  end
  
  def show_comments?(student)
    if student.is_super_admin? || self.task.instructor == student
      return true
    elsif self.task.permission.discussionable == 'self' && self.student == student
      return true
    elsif self.task.permission.discussionable == 'group'
      return true
    else
      return false
    end
  end
  
end
