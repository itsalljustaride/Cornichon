class Comment < ActiveRecord::Base  
  acts_as_tree :order => 'created_at'
  has_attached_file :audio, :url => "#{ActionController::Base.relative_url_root}/system/audio/:id/:basename.:extension",
                            :path => ":rails_root/public/system/audio/:id/:basename.:extension"
  validates_attachment_content_type :audio, :content_type => ['audio/mpeg', 
                                                              'audio/x-mpeg', 
                                                              'audio/mp3', 
                                                              'audio/x-mp3', 
                                                              'audio/mpeg3', 
                                                              'audio/x-mpeg3', 
                                                              'audio/mpg', 
                                                              'audio/x-mpg', 
                                                              'audio/x-mpegaudio',
                                                              'video/quicktime',
                                                              'audio/quicktime' ],
                                              :message => 'Not a valid audio file.'
  
  
  belongs_to  :sessionrecording
  belongs_to  :student
  
  # Currently this isn't doing any filtering, but could be used to filter more finitely the comments if needed.
  named_scope :viewable_by, lambda { |args|
    user = args.first
    task = args.last
    {:include => [:student, :sessionrecording, :usersession, :task]}
    case
      when user.is_super_admin? then {}
      when task.instructor == user then {}
      when task.permission && task.permission.discussionable == 'group' then {}
      else {}
    end
    {:order => 'created_at ASC'}
  }
      
  def grouptask
    return Grouptask.find(Usersession.find(self.sessionrecording.associatedusersessionid).associatedgrouptaskid)
  end
  
  def sessionrecording
    return Sessionrecording.find(self.sessionrecording_id)
  end
  
  #This isn't used anywhere yet.
  def set_audio_length(file)
    Mp3Info.open(file) do |mp3| 
      self.audio_length = mp3.length
    end
  end
    
end