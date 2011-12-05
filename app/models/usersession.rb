class Usersession < ActiveRecord::Base
  establish_connection :dill_db
  set_table_name "usersession"
  
  has_many      :sessionrecordings, :order => "positioninlesson ASC",  :foreign_key => "associatedusersessionid"
  belongs_to    :student,   :foreign_key => "associatedstudentsid"
  belongs_to    :grouptask, :foreign_key => "associatedgrouptaskid"
  
  named_scope :not_empty, {
    :joins => :sessionrecordings,
    :conditions => ['(SELECT count(*) as total_recordings FROM sessionrecording) > 0']
  }

end
