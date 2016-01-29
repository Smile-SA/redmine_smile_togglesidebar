require File.expand_path('../../test_helper', __FILE__)

# Standalone test :
# bundle exec ruby plugins/redmine_smile_togglesidebar/test/integration/toggel_sidebar_test.rb
class ToggleSidebarTest < Redmine::IntegrationTest
  fixtures :projects,
           :issues,
           :users,
           :roles,
           :members,
           :member_roles,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :issue_statuses

  def test_toggle_on_issues_index
    log_user('jsmith', 'jsmith')

    ##############
    # Issues/index
    get '/projects/ecookbook/issues'
    assert_response :success
    assert_template 'issues/index'

    assert_select 'div#main.nosidebar', 0, "The nosidebar class on div#main should not exist (sidebar displayed)"

    ##############
    # Hide sidebar
    xhr :get, '/sidebar/toggle', :original_controller => 'issues', :original_action => 'index'

    ##############
    # Issues/index
    get '/projects/ecookbook/issues'
    assert_response :success
    assert_template 'issues/index'

    assert_select 'div#main.nosidebar', 1, "The nosidebar class on div#main should exist (sidebar not displayed)"
  end
end