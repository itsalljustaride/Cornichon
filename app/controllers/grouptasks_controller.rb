class GrouptasksController < ApplicationController
  
  before_filter :protect, :only => [:index, :show]
  protect_from_forgery :only => [:index]
    
  def index
    @title = "Cornichon - Tasks List"
    @current_user_proftasks = Grouptask.proftasks(current_user.sid)
    @current_user_studenttasks = current_user.grouptasks.reject {|n| !n.student_has_recorded_in?(current_user) || !n.permission || !n.permission.isselfviewable }
  end
  
  def show
    @task = Grouptask.find_by_id(params[:id], :include => [:usersessions, :sessionrecordings, :students])
    @title = "Cornichon - #{@task.taskname}"
    @tasksessions = []
    
    # This will create the permissions if they don't exist yet, since we can't control creation of permissions along with tasks
    @permission = Permission.find_or_create_by_grouptask_id(@task.id)
    
    unless current_user.can_view_task?(@task)
      redirect_back :action => "index", :controller => "logins"
      flash[:notice] = "You're not authorized to view that task."
    end
    
    if @task.permission
      if @task.permission.isgroupviewable || @task.creatorstudentid == current_user.sid || current_user.is_super_admin?
        @tasksessions = @task.usersessions.sort_by { |p| p.student.lastname }
      else
        @tasksessions << @task.usersessions.find_by_associatedstudentsid(current_user.sid)
      end
    end
        
    if params[:show_comments_for]
      @show_comments_rec = Sessionrecording.find_by_id(params[:show_comments_for])
    else
      @show_comments_rec = false
    end
  end
      
  def load_comments_pane
    @task = Grouptask.find_by_id(params[:id], :include => [:usersessions, :sessionrecordings, :students])
    @rec = Sessionrecording.find_by_id(params[:rec], :include => [:comments])
    @parent_comments = @rec.comments.viewable_by([current_user,@task]).find(:all, :conditions => "parent_id IS NULL")
  end
  
  def reply_to_comment
    @parent = Comment.find(params[:parent], :include => [:sessionrecording, :student])
    @recording = @parent.sessionrecording
    @task = @parent.grouptask
  end
    
  def create_comment
    @comment = Comment.new(params[:comment])
    
    respond_to do |format|
      if @comment.save
        format.js
      else
        # flash[:notice] = "Comment was not saved!"
        format.js
      end
    end
  end
  
  def create_comment_reply
    @comment = Comment.new(params[:comment])
    
    respond_to do |format|
      if @comment.save
        format.js
      else
        # flash[:notice] = "Comment was not saved!"
        format.js
      end
    end
  end
  
  def edit_comment
    @comment = Comment.find(params[:id])
  end
  
  def update_comment
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.js
      else
        # flash[:notice] = "Comment was not updated!"
        format.js
      end
    end
  end
    
  def destroy_comment
    @comment = Comment.find(params[:id])
    
    respond_to do |format|
      if @comment.destroy
        format.js
      else
        #flash[:notice] = "Comment was not deleted!"
        format.js
      end
    end
  end
    
end

def protect
  unless session[:user_id]
    flash[:notice] = "Please log in first!!!"
    redirect_away url_for(:controller => 'logins')
    return false
  end
end