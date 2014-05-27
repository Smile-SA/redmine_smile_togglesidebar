# Smile - application_helper enhancement
# module Smile::Helpers::ApplicationOverride
#
# - 1/ module ::ToggleSidebar
#      Change #26860 Bouton + / - pour cacher le bandeau de droite

module Smile
  module Helpers
    module ApplicationOverride
      # extend ActiveSupport::Concern

      #*****************
      # 1/ ToggleSidebar
      module ToggleSidebar
        TOGGLE_SIDEBAR_INSTANCE_METHODS = [
          :button_toggle_sidebar, # 1/ new method
          :session_name_show_sidebar, # 2/ new method
          :image_toggle_sidebar # 3/ new method
        ]

        def self.extended(base)
          base.class_eval do
            # 1/
            def button_toggle_sidebar(float_right=true, no_margin_right=true, span=true)
              _style = ''
              if float_right || no_margin_right
                _style = ' style="'
                _style += 'float:right' if float_right
                _style += '; ' if float_right && no_margin_right
                _style += 'margin-right:0' if float_right && no_margin_right
                _style += '"'
              end

              show_sidebar = session[session_name_show_sidebar(controller_name, action_name)]
              show_sidebar = true if show_sidebar.nil?
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
                    :original_action => action_name
                  },
                  :class => _class
                )
              else
                toggle_distant = link_to(
                  image_toggle_tag,
                  sidebar_toggle_url(
                    :original_controller => controller_name,
                    :original_action => action_name
                  ),
                  :class => _class,
                  :remote => true
                )
              end

              if span
                "<span#{ _style }>#{ rjs_distant }</span>"
              else
                toggle_distant
              end
            end

            # 2/
            def session_name_show_sidebar(p_controller_name, p_action_name)
              "#{p_controller_name}_#{p_action_name}_show_sidebar"
            end

            # 3/
            def image_toggle_sidebar(p_show_sidebar)
              if ! defined?(@@image_toggle_sidebar_true)
                @@image_toggle_sidebar_true = '/plugin_assets/redmine_smile_togglesidebar/images/'
                @@image_toggle_sidebar_false = '/plugin_assets/redmine_smile_togglesidebar/images/'
                @@image_toggle_sidebar_true += 'maximize.png'
                @@image_toggle_sidebar_false += 'minimize.png'
              end

              if p_show_sidebar
                @@image_toggle_sidebar_true
              else
                @@image_toggle_sidebar_false
              end
            end
          end # base.class_eval do

          Rails.logger.info "o=>#{base.name}           instance_methods  #{base.instance_methods.select{|m| TOGGLE_SIDEBAR_INSTANCE_METHODS.include?(m)}.join(', ')} -- (Smile::Helpers::ApplicationOverride::ToggleSidebar::InstanceMethods)"
        end # def self.extended
      end # module ToggleSidebar
    end # module ApplicationOverride
  end # module Helpers
end # module Smile
