module GrouptasksHelper
  
  def edit_perms_link
    if current_user.can_edit_task_perms?(@task)
      link_to 'Edit Task Permissions', new_or_edit_permission_path(@task.permission, @task)
    end
  end
    
  def build_table
    text = ""
    text << "<table>\r"
    sid = ""
    @tasksessions.each do |session|
      if session.sessionrecordings.length != 0
        if session.associatedstudentsid != sid
          text << "<tr class=\"name\"><th>#{session.student.lastname.capitalize}, #{session.student.firstname}</th><th></th></tr>"
          sid = session.associatedstudentsid  
          session.sessionrecordings.each do |recording|
            text << "<tr><td>#{recording.cliptitle}</td><td><embed src=\"#{recording.url_to_file}\" width=\"100\" height=\"20\"controller=\"true\" loop=\"False\" autoplay=\"false\" KEEPASPECTRATIO=\"true\" playrate=\"100\" quality=\"high\" volume =\"100\"></td></tr>\r"
          end   
        else
          session.sessionrecordings.each do |recording|
            text << "<tr><td>#{recording.cliptitle}</td><td><embed src=\"#{recording.url_to_file}\" width=\"100\" height=\"20\"controller=\"true\" loop=\"False\" autoplay=\"false\" KEEPASPECTRATIO=\"true\" playrate=\"100\" quality=\"high\" volume =\"100\"></td></tr>\r"
          end 
          sid = session.associatedstudentsid         
        end 
      end
    end
    text << "</table>"
    return text 
  end
  
  def comment_kind(task)
    if current_user == task.instructor
      return 1
    else
      return 0
    end
  end
  
  def reply_to_comment(comment)
    link_to_remote "Reply", :url => { :action => "reply_to_comment", :parent => comment }
  end
  
  def audio_reply(comment)
    link_to 'Audio Reply', url_for(:controller => 'comments', :action => 'new', :parent => comment, :rec => comment.sessionrecording)
  end
    
  def comment_delete_if_auth(comment)
    if comment.student == current_user
      link_to_remote "Delete", :url => { :action => "destroy_comment", :id => comment.id }
    end
  end
  
  def comment_edit_if_auth(comment)
    if comment.student == current_user
      link_to "Edit", edit_comment_path(comment)
    end
  end
  
  def load_comment_pane_if_needed
    if @show_comments_rec
      javascript_tag remote_function(:url => {:controller => 'grouptasks', :action => 'load_comments_pane', :id => @task, :rec => @show_comments_rec})
    end
  end
    
end
