module PermissionsHelper
  def new_or_edit_permission_path(permission, grouptask)
    permission ? edit_permission_path(permission) : new_permission_path(:grouptask_id => grouptask)
  end
end
