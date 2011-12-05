module StatisticsHelper

  def users_with_frequency(cutoff)
    begin
      num_of_users = Student.use_frequency([@days_ago,cutoff]).count
      return "#{num_of_users} (#{((num_of_users/@num_of_total_profs.to_f)*100).round}%)"
    rescue
      return "No results"
    end
  end
  
  def sync_vs_async
    begin
      return "#{@sync_tasks} (#{((@sync_tasks.to_f/@num_of_total_tasks.to_f)*100).round}%) / #{@async_tasks} (#{((@async_tasks.to_f/@num_of_total_tasks.to_f)*100).round}%)"
    rescue
      return "No results"
    end
  end
  
  def lesson_vs_non
    begin
      return "#{@lesson_tasks} (#{((@lesson_tasks.to_f/@num_of_total_tasks.to_f)*100).round}%) / #{@nonlesson_tasks} (#{((@nonlesson_tasks.to_f/@num_of_total_tasks.to_f)*100).round}%)"
    rescue
      return "No results"
    end
  end
  
  def user_tasks_totals
    thetext = "<table><tr><th>Instructor Name</th><th># Tasks</th></tr>"
    for prof in @profs.each do
      taskcount = Grouptask.created_days_ago(@days_ago).count(:all, :conditions => {:creatorstudentid => prof.sid})
      thetext << "<tr><td>#{prof.firstname} #{prof.lastname}</td><td>#{taskcount}</td></tr>"
    end
    thetext << "<tr><th>Total</th><th>#{@num_of_total_tasks}</th></tr>"
    thetext << "</table>"
    return thetext
  end
  
end
