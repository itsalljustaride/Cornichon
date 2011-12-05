class Grouptask < ActiveRecord::Base
  establish_connection :dill_db
  set_table_name "grouptask"
  
  has_many      :usersessions, :foreign_key => "associatedgrouptaskid"
  has_many      :sessionrecordings, :through => :usersessions, :order => "associatedusersessionid"
  has_many      :students, :through => :usersessions
  has_one       :permission
  
  #Scopes for Task index view
  named_scope   :proftasks, ( lambda do |sid| 
    { :include => [:permission, :usersessions, :sessionrecordings], 
      :conditions => ["creatorstudentid = ?", sid] }
  end )
  
  named_scope   :studenttasks, ( lambda do |sid| 
    { :include => [:usersessions, :sessionrecordings, :students, :permission],
      :conditions => ["student.sid = ?", sid] }
  end ) #This one doesn't work right now because can't get it to filter out empty usersessions
  
  #Scopes for Statistics controller
  named_scope :created_days_ago, lambda { |duration| { 
    :conditions => ['creationdate > ? AND creatorstudentid IS NOT NULL', Date.today-duration] 
  }}
  named_scope :sync_tasks, { 
    :conditions => ['creatorstudentid IS NOT NULL AND issynchronizedtask = 1'] 
  }
  named_scope :async_tasks, { 
    :conditions => ['creatorstudentid IS NOT NULL AND issynchronizedtask = 0'] 
  }
  named_scope :lesson_tasks, { 
    :conditions => ['creatorstudentid IS NOT NULL AND associatedlessonid >= 1'] 
  }
  named_scope :nonlesson_tasks, { 
    :conditions => ['creatorstudentid IS NOT NULL AND associatedlessonid IS NULL'] 
  }
    
  def instructor
    return Student.find(:first, :conditions => {:sid => self.creatorstudentid})
  end
    
  def student_has_recorded_in?(student)
    if self.usersessions.not_empty.find(:all, :conditions => {:associatedstudentsid => student.sid}).count > 0
      return true
    else
      return false
    end
  end
      
end
