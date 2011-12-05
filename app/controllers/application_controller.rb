# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user
  before_filter :setup_session_key
  

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '07d61250af576e74fc5fd32caf0c45b9'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging "password"
  
  private
  
    def setup_session_key
      # Pick a unique cookie name to distinguish our session data from others'
      request.session_options[:session_key] = '_cornichon_session_id'
    end
  
    def current_user
      if session[:user_id]
        return Student.find(:first, :conditions => [ "lower(shortname) = ?", session[:user_id].downcase ])
      else
        return false
      end
    end
    
    # redirect somewhere that will eventually return back to here
    def redirect_away(*params)
      session[:original_uri] = request.request_uri
      redirect_to(*params)
    end

    # returns the person to either the original url from a redirect_away or to a default url
    def redirect_back(*params)
      uri = session[:original_uri]
      session[:original_uri] = nil
      if uri
        redirect_to uri
      else
        redirect_to(*params)
      end
    end
  
end

DILL_WEB_FULL_URL = "#{SysParam.get(:DiLLWebServerHostURL)}cgi-bin/WebObjects/DiLL.woa"