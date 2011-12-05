class Directoryauthority < ActiveRecord::Base
  establish_connection :dill_db
  set_table_name "directoryauthority"
  
  named_scope :active_authorities, :conditions => {:isactive => 1, :isdirectoryauthority => 1}, :order => 'orderinauthenticationsearch'
  named_scope :ldap_auths, :conditions => {:authenticationenginetype => 'LDAP'}
  named_scope :kerberos_auths, :conditions => {:authenticationenginetype => 'KRB'}
  
  def ldap_host
    return URI.parse(self.ldapbaseurl).host
  end
  
  def ldap_port
    if self.ldapshouldusessl != 0
      return 389
    else
      return 389
    end
  end
  
  def ldap_auth_method
    return self.ldapauthmethod.downcase
  end
  
  def authenticate(username, password)
    #This only works for LDAP hosts right now. Need Kerberos examples to build KRB auth funtionality.
    
    conn = Net::LDAP.new(:host => self.ldap_host, :port => self.ldap_port)
    
    filter = Net::LDAP::Filter.eq( self.ldapuseridattribute, username )
    attrs = []
    
    begin
      if self.ldapshouldbind != 0
        dn = ""
        conn.auth self.ldapsearchdn, self.ldapsearchpassword
        conn.bind do
          logger.info "Searching #{self.referencetitle} for user #{username}"
          conn.search( :base => self.ldapsearchbase, :attributes => attrs, :scope => Net::LDAP::SearchScope_WholeSubtree, :filter => filter, :return_result => true ) do |entry|
            dn = entry.dn
            logger.info "Search found dn \"#{dn}\""
          end
        end
        logger.info "Attempting bind with dn \"#{dn}\" and passwd \"#{password}\""
        if conn.authenticate dn, password
          logger.info "Success! Bound and determined!"
          return true
        else
          logger.info "Bind failed. Most likely passwd was incorrect."
          return false
        end
      else
        logger.info "Searching #{self.referencetitle} for user #{username}"
        conn.search( :base => self.ldapsearchbase, :attributes => attrs, :scope => Net::LDAP::SearchScope_WholeSubtree, :filter => filter, :return_result => true ) do |entry|
          logger.info "Search found dn \"#{entry.dn}\""
          if conn.authenticate entry.dn, password
            logger.info "Success! Bound and determined!"
            return true
          else
            logger.info "Bind failed. Most likely passwd was incorrect."
            return false
          end
        end
      end
    rescue Net::LDAP::LdapError
      return false
    end
  end
  
end