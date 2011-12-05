class StatisticsController < ApplicationController
  
  before_filter :protect, :only => [:index]
  protect_from_forgery :only => [:index]
    
  def index
    @title = "Cornichon - Usage Stats"
    
    @days_ago = params[:days].to_i
    
    @the_tasks = Grouptask.created_days_ago(@days_ago)
    @num_of_total_tasks = @the_tasks.count
    
    @profs = Student.used_in_past(@days_ago)
    @num_of_total_profs = @profs.count
    
    @sync_tasks = @the_tasks.sync_tasks.count
    @async_tasks = @the_tasks.async_tasks.count
    @lesson_tasks = @the_tasks.lesson_tasks.count
    @nonlesson_tasks = @the_tasks.nonlesson_tasks.count
  end
end

def protect
  unless session[:user_id] && current_user.is_super_admin?
    flash[:notice] = "Please log in first!!!"
    redirect_away url_for(:controller => 'logins')
    return false
  end
end