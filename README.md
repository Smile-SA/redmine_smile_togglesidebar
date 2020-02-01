redmine_smile_togglesidebar
===========================

Redmine plugin that adds a button to hide the right sidebar

## How it works

It stores a session cookie for each controller and action, to memorize the state of the sidebar display

## To enable the [+] / [-] button

- The activation of the  [+] / [-] button is **now automatic** when a sidebar is present

## Remarks

- The Sidebar display state is **not** persisted between sessions in a cookie
- As there is no hook at the beginning of the body layout, we use the following trick : the button is inserted just before the flash messages (even if no message)
- Fixed an issue with https when ssl managed by a front proxy (request.ssl? does not work)
- Full tests have been added
- Compatible with Redmine 1.2.1 -> 4.0.1
- Compatible with Relative root set with :
```ruby
Redmine::Utils::relative_url_root
```

## TODO

- remove duplication of **session_name_show_sidebar** method
- Ask Jean-Philippe Lang a new hook at the beginning of the layout body
- Implement a cross-session cookie version ?
- finish refresh sidebar state on focus

## INSTALLATION

- With git
```shell
# go to your Redmine app root
cd plugins
git clone https://github.com/Smile-SA/redmine_smile_togglesidebar.git
# Restart / Reload your Redmine
```

- Without git :
The same just copy the plugin archive in the *plugins* folder with the correct name : *redmine_smile_togglesidebar*

- No plugin migration
- New hide sidebar icon will automatically be available in any page where the *Sidebar is enabled*.

Enjoy !


## Changelog

* **V1.0.7** Overrides list in plugin settings page


<kbd>![alt text](https://compteur-visites.ennder.fr/sites/32/token/githubtsb/image "Logo") <!-- .element height="10%" width="10%" --></kbd>
