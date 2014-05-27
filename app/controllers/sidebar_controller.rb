#
# For the Smile Redmine plugin
# 2012
#
class SidebarController < ApplicationController
  unloadable

  # Smile specific 2013 Change #26860 Bouton + / - pour cacher le bandeau de droite
  def toggle
    original_action_name = params[:original_action]
    original_controller_name = params[:original_controller]

    _session_name_show_sidebar = session_name_show_sidebar(original_controller_name, original_action_name)
    show_sidebar = session[_session_name_show_sidebar]
    show_sidebar = true if show_sidebar.nil?

    session[_session_name_show_sidebar] = !show_sidebar

    respond_to do |format|
      format.js {
        render(:template => 'sidebar/toggle', :layout => false)
      }
    end
  end


private

  # Smile specific 2013 Change #26860 Bouton + / - pour cacher le bandeau de droite
  def session_name_show_sidebar(p_controller_name, p_action_name)
    p_controller_name + '_' + p_action_name + '_show_sidebar'
  end
end
