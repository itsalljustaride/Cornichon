class Student < ActiveRecord::Base
  establish_connection :dill_db
  set_table_name "student"
  set_primary_key :sid
  
  has_many      :usersessions, :foreign_key => "associatedstudentsid"
  has_many      :grouptasks, :through => :usersessions
  has_many      :sessionrecordings, :through => :usersessions
  has_many      :comments
  has_one       :administrator, :foreign_key => "shortname", :primary_key => "shortname"
    
  named_scope :use_frequency, lambda {|args| {
    :conditions => ['(SELECT count(*) as total_tasks FROM grouptask WHERE creatorstudentid = sid AND creationdate > ?) > ?', Date.today-args.first, args.second]
  }}
  
  named_scope :used_in_past, lambda {|days_ago| {
    :conditions => ['(SELECT count(*) as total_tasks FROM grouptask WHERE creatorstudentid = sid AND creationdate > ?) > 0', Date.today-days_ago] 
  }}
        
  def is_super_admin?
    if self.administrator && self.administrator.isgod
      return true
    else
      return false
    end
  end
  
  def can_view_task?(task)
    cleared = false
    if task.permission
      if task.student_has_recorded_in?(self) && (task.permission.isgroupviewable || task.permission.isselfviewable)
        logger.info "User has been cleared to view task because they recorded in it"
        cleared = true
      elsif task.creatorstudentid == self.sid
        logger.info "User has been cleared to view task because they created it"
        cleared = true
      else
        logger.info "User has NOT been cleared to view task"
        cleared = false
      end
    elsif self.is_super_admin?
      logger.info "User has been cleared to view task because they are a superadmin"
      cleared = true
    end
    return cleared
  end
  
  def can_edit_task_perms?(task)
    case
    when self.is_super_admin?
      return true
    when task.instructor == self
      return true
    else
      return false
    end
  end
      
end
