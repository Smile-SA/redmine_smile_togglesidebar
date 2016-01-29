require File.expand_path('../../test_helper', __FILE__)

# Standalone test :
# bundle exec ruby plugins/redmine_smile_togglesidebar/test/functionals/sidebar_controller_test.rb
class SidebarControllerTest < ActionController::TestCase
  def setup
    @request.session[:user_id] = 2
  end

  def test_toggle
    #############
    # First click for controller and action
    assert_nil session['issues_show_show_sidebar'], 'before 1st click, session variable for controller and action should be nil'
    xhr :get, :toggle, :original_controller => 'issues', :original_action => 'show'

    assert_response :success
    assert_template 'toggle'

    # always in the response
    assert response.body.include?("removeClass('nosidebar');"), 'JS response should include : removeClass(\'nosidebar\');'

    # In the response only if hiding sidebar
    assert response.body.include?("if (false)"), 'after 1st click, JS response should include : if (false)'

    # State stored in session
    assert_equal session['issues_show_show_sidebar'], false, 'after 1st click, session variable for controller and action should be : false'

    ##############
    # Second click
    xhr :get, :toggle, :original_controller => 'issues', :original_action => 'show'

    # In the response only if showing sidebar
    assert response.body.include?("if (true)"), 'after 2nd click, JS response should include : if (true)'

    # State stored in session
    assert_equal session['issues_show_show_sidebar'], true, 'after 2nd click, session variable for controller and action should be : true'

    #############
    # Third click
    xhr :get, :toggle, :original_controller => 'issues', :original_action => 'show'

    # In the response only if hiding sidebar
    assert response.body.include?("if (false)"), 'after 3rd click, JS response value should include : if (false)'

    # State stored in session
    assert_equal session['issues_show_show_sidebar'], false, 'after 3rd click, session variable for controller and action should be : false'
  end
end