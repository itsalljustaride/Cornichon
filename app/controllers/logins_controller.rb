class LoginsController < ApplicationController
    
  def index
    @title = "Cornichon - Login"
  end
  
  def user_auth
    if params[:username] && params[:password]
      username = params[:username]
      password = params[:password]
      authenticated = false
      
      if RAILS_ENV == 'development'
        # Turn this on to skip authentication for dev purposes
        #authenticated = true
      end
      
      if !authenticated
        for auth in Directoryauthority.active_authorities.ldap_auths
          if auth.authenticate(username,password)
            authenticated = true
            logger.info "Successfully Authenticated \"#{username}\" via #{auth.referencetitle}"
            break
          else
            authenticated = false
          end
        end
      end
      
      if authenticated && Student.find(:first, :conditions => [ "lower(shortname) = ?", params[:username].downcase ])
        user = Student.find(:first, :conditions => [ "lower(shortname) = ?", params[:username].downcase ])
        logger.info "Setting current user to #{user.shortname}"
        session[:user_id] = user.shortname
        logger.info "Session user is #{session[:user_id]}"
        if session[:original_uri]
          redirect_back
        else
          redirect_to :action => 'index', :controller => 'grouptasks'
        end
      else
        logger.info "Login Unsuccessful"
        redirect_to :controller => 'logins'
        flash[:notice] = "Invalid username or password. <br/>Please try again."
      end
    end
  end
      
  def logout
    session[:user_id] = nil
    redirect_to :controller => 'logins'
    flash[:notice] = "You are now logged out."
  end
    
end
