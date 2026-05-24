require "gtk4"
require "gtksourceview5"

app = Gtk::Application.new("com.github.hozo", :flags_none)

# this holds all the application styling
def css_styling(window)
  css_provider = Gtk::CssProvider.new
  css_provider.load_from_path("style.css")

  Gtk::StyleContext.add_provider_for_display(
    window.display,
    css_provider,
    Gtk::StyleProvider::PRIORITY_APPLICATION
  )
end

def build_window(application)
  window = Gtk::ApplicationWindow.new(application)
  window.set_default_size(600, 400)
  window.set_title("")
  window.titlebar = Gtk::HeaderBar.new
  window
end

app.signal_connect "activate" do |application|
  window = build_window(application)
  css_styling(window)

  buffer = GtkSource::Buffer.new
  view = GtkSource::View.new(buffer)
  view.show_line_numbers = true
  view.vexpand = true
  scrolled = Gtk::ScrolledWindow.new
  scrolled.child = view

  menu_model = Gio::Menu.new

  file_menu = Gio::Menu.new
  file_menu.append("Save", "app.save")
  menu_model.append_submenu("File", file_menu)

  menu_button = Gtk::MenuButton.new
  menu_button.icon_name = "open-menu-symbolic"
  menu_button.menu_model = menu_model

  header = Gtk::HeaderBar.new
  header.pack_end(menu_button)
  window.titlebar = header

  scrolled.set_child(view)
  window.set_child(scrolled)
  window.present
end

app.run
