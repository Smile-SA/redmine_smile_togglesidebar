# Smile - application_helper enhancement
# module Smile::Helpers::ApplicationOverride
#
# - 1/ module ::ToggleSidebar
#      Bouton "+" to hide / show the sidebar

module Smile
  module Helpers
    module ApplicationOverride
      # extend ActiveSupport::Concern

      #**************
      # ToggleSidebar
      module ToggleSidebar
        def self.extended(base)
          toggle_sidebar_instance_methods = [
            :button_toggle_sidebar,      # 1/ New method
            :session_name_show_sidebar,  # 2/ New method
            :image_toggle_sidebar,       # 3/ New method
            :sidebar_content?,           # 4/ EXTENDED V4.0.0 OK
            :render_flash_messages,      # 5/ EXTENDED V4.0.0 OK
          ]

          base.class_eval do
            # 1/ New method
            def button_toggle_sidebar(float_right=true, no_margin_right=true, span=true)
              _style = ''

              # TODO : not used
              if float_right || no_margin_right
                _style = ' style="'
                _style += 'float:right' if float_right
                _style += '; ' if float_right && no_margin_right
                _style += 'margin-right:0' if float_right && no_margin_right
                _style += '"'
              end

              show_sidebar = session[session_name_show_sidebar(controller_name, action_name)]
              show_sidebar = true if show_sidebar.nil?

              # TODO : not used
              if span
                _class = nil
              else
                _class = 'icon-toggle'
              end

              image_toggle_tag = "<img src=\"#{image_toggle_sidebar(show_sidebar)}\" id=\"sidebar_view\" />".html_safe

              if Rails::VERSION::MAJOR < 3
                toggle_distant = link_to_remote(
                  image_toggle_tag,
                  :url => {
                    :controller => 'sidebar',
                    :action => 'toggle',
                    :original_controller => controller_name,
                    :original_action => action_name,
                    :protocol => Setting.protocol
                  },
                  :class => _class
                )
              else
                toggle_distant = link_to(
                  image_toggle_tag,
                  sidebar_toggle_url(
                    :original_controller => controller_name,
                    :original_action => action_name,
                    :protocol => Setting.protocol
                  ),
                  :class => _class,
                  :remote => true
                )
              end

              # TODO : not used
              if span
                "<span#{ _style }>#{ toggle_distant }</span>".html_safe
              else
                toggle_distant
              end
            end

            # 2/ New method
            def session_name_show_sidebar(p_controller_name, p_action_name)
              "#{p_controller_name}_#{p_action_name}_show_sidebar"
            end

            # 3/ New method
            #    Manages redmine is sub-folder
            def image_toggle_sidebar(p_show_sidebar)
              if ! defined?(@@image_toggle_sidebar_true)
                @@image_toggle_sidebar_true = "#{Redmine::Utils::relative_url_root}/plugin_assets/redmine_smile_togglesidebar/images/"
                @@image_toggle_sidebar_false = @@image_toggle_sidebar_true
                @@image_toggle_sidebar_true += 'maximize.png'
                @@image_toggle_sidebar_false += 'minimize.png'
              end

              if p_show_sidebar
                @@image_toggle_sidebar_true
              else
                @@image_toggle_sidebar_false
              end
            end

            # 4/ EXTENDED RM 4.0.0 OK
            #    To be able to hide the sidebar (change css class)
            def sidebar_content_with_toggle?
              show_sidebar = sidebar_content_without_toggle?

              # In helper method => controller and action name available
              session_show_sidebar = session[session_name_show_sidebar(controller_name, action_name)]

              # Upstream behaviour if no session information
              return show_sidebar if session_show_sidebar.nil?

              return show_sidebar && session_show_sidebar
            end

            # 5/ EXTENDED RM 4.0.0 OK
            #    Trick to have the button as the first html element in body
            def render_flash_messages_with_toggle
              flash_messages_rendered = render_flash_messages_without_toggle

              if content_for(:sidebar).present?
                return '<div id="toggle-sidebar" style="float: right; position: relative; margin-left: 4px">'.html_safe +
                  button_toggle_sidebar(false, false, false).html_safe +
                  '</div>'.html_safe +
                  flash_messages_rendered
                  # TODO finish refresh sidebar state on focus
                  # "<script>$(window).on('focus', function(){console.log('focus');});</script>".html_safe
              end

              flash_messages_rendered
            end
          end # base.class_eval do

          trace_prefix         = "#{' ' * (base.name.length + 15)}  --->  "
          module_name          = 'SM::H::ApplicationOverride::ToggleSidebar'
          last_postfix         = "< (#{module_name})"

          base.instance_eval do
            alias_method :sidebar_content_without_toggle?, :sidebar_content?
            alias_method :sidebar_content?, :sidebar_content_with_toggle?

            alias_method :render_flash_messages_without_toggle, :render_flash_messages
            alias_method :render_flash_messages, :render_flash_messages_with_toggle
          end # base.instance_eval do

          SmileTools.trace_override "#{base.name}         alias_method  sidebar_content?, :toggle " + last_postfix,
            true,
            :redmine_smile_togglesidebar

          SmileTools.trace_override "#{base.name}         alias_method  render_flash_messages, :toggle " + last_postfix,
            true,
            :redmine_smile_togglesidebar


          smile_instance_methods = base.instance_methods.select{|m|
              toggle_sidebar_instance_methods.include?(m) &&
                base.instance_method(m).source_location.first =~ SmileTools.regex_path_in_plugin(
                  'lib/helpers/smile_helpers_application',
                  :redmine_smile_togglesidebar
                )
            }

          missing_instance_methods = toggle_sidebar_instance_methods.select{|m|
            !smile_instance_methods.include?(m)
          }

          if missing_instance_methods.any?
            trace_first_prefix = "#{base.name} MIS instance_methods  "
          else
            trace_first_prefix = "#{base.name}     instance_methods  "
          end

          SmileTools::trace_by_line(
            (
              missing_instance_methods.any? ?
              missing_instance_methods :
              smile_instance_methods
            ),
            trace_first_prefix,
            trace_prefix,
            last_postfix,
            :redmine_smile_togglesidebar
          )

          if missing_instance_methods.any?
            raise trace_first_prefix + missing_instance_methods.join(', ') + '  ' + last_postfix
          end
        end # def self.extended
      end # module ToggleSidebar
    end # module ApplicationOverride
  end # module Helpers
end # module Smile
