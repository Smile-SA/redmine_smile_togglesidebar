# encoding: UTF-8

require 'redmine'

Rails.logger.info 'Starting Redmine Smile Hide Sidebar plugin for RedMine'


plugin_name = 'redmine_smile_togglesidebar'

Redmine::Plugin.register plugin_name.to_sym do
  name 'Redmine - Smile - Hide / Show Sidebar Button'
  author 'Jérôme BATAILLE'
  author_url 'mailto:Jerome BATAILLE <redmine-support@smile.fr>?subject=' + plugin_name
  description 'Adds a button to hide / show the right sidebar'
  url 'https://github.com/Smile-SA/' + plugin_name
  version '1.0.4'
  requires_redmine :version_or_higher => '1.2.1'

  #Plugin home page
  settings :default => HashWithIndifferentAccess.new(), :partial => 'settings/' + plugin_name
end


require File.dirname(__FILE__) + '/lib/helpers/smile_helpers_application'


if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
end

#Executed each time the classes are reloaded
if !defined?(rails_dispatcher)
  if Rails::VERSION::MAJOR < 3
    rails_dispatcher = Dispatcher
  else
    rails_dispatcher = Rails.configuration
  end
end

this_plugin = Redmine::Plugin::find(plugin_name)
plugin_version = '?.?'
if this_plugin
  plugin_version = this_plugin.version
end


rails_dispatcher.to_prepare do
  ::Rails.logger.info "o=>\\__ #{plugin_name} V#{plugin_version}"

  #######################
  # **** Controllers ****

  ###################
  # **** Helpers ****
  unless ApplicationHelper.include? Smile::Helpers::ApplicationOverride::ToggleSidebar
#    Rails.logger.info "o=>ApplicationHelper.extend Smile::Helpers::ApplicationOverride::ToggleSidebar"
    # ApplicationHelper is a module
    ApplicationHelper.send(:extend, Smile::Helpers::ApplicationOverride::ToggleSidebar)
  end

  ::Rails.logger.info 'o=>/--'
end
