class Permission < ActiveRecord::Base
  belongs_to    :grouptask
  
  ENTRY_VALUES = ['none','self','group']
  
  def isselfviewable
    if self.viewable == 'self' || self.viewable == 'group'
      return true
    else
      return false
    end
  end
  
  def isgroupviewable
    if self.viewable == 'group'
      return true
    else
      return false
    end
  end
  
  def isselfdiscussionable
    if self.discussionable == 'self' || self.discussionable == 'group'
      return true
    else
      return false
    end
  end
  
  def isgroupdiscussionable
    if self.discussionable == 'group'
      return true
    else
      return false
    end
  end
  
  def isselfdownloadable
    if self.downloadable == 'self' || self.downloadable == 'group'
      return true
    else
      return false
    end
  end
  
  def isgroupdownloadable
    if self.downloadable == 'group'
      return true
    else
      return false
    end
  end
  
end
