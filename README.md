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
- There are not **yet** tests on this feature
- Fixed an issue with https when ssl managed by a front proxy (request.ssl? does not work)
- Full tests have been added

### TODO

- remove duplication of **session_name_show_sidebar** method
- Ask JPL a new hook at the beginning of the layout body
- Implement a cross-session cookie version ?
- finish refresh sidebar state on focus

Enjoy !