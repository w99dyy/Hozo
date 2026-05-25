require "gtk4"
require "gtksourceview5"
require_relative "file_picker"
require_relative "syntax_highlighting"
include SyntaxHighlighting

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

  header = Gtk::HeaderBar.new
  title_label = Gtk::Label.new("untitled")
  header.pack_start(title_label)
  title_label.add_css_class("title-label")
  window.show_menubar = true
  window.titlebar = header
  [window, title_label]
end

app.signal_connect "activate" do |application|
  window, title_label = build_window(application)
  css_styling(window)

  # Text rendering
  buffer = GtkSource::Buffer.new
  view = GtkSource::View.new(buffer)
  view.show_line_numbers = true
  view.vexpand = true
  view.highlight_current_line = true
  view.indent_on_tab = true
  view.auto_indent = true
  view.tab_width = 4

  scrolled = Gtk::ScrolledWindow.new
  # view.set_wrap_mode(Gtk::WrapMode::WORD)

  # submenu of Files menu
  file_menu = Gio::Menu.new
  file_menu.append("New", "app.new")
  file_menu.append("Open", "app.open")
  file_menu.append("Save", "app.save")

  # open file action
  open_action = Gio::SimpleAction.new("open", nil)
  open_action.signal_connect "activate" do
    FilePicker.open_file(window) do |content, filename|
      buffer.text = content
      current_file = filename
      syntax_highlight(buffer, current_file)
      title_label.set_text(" #{File.basename(filename)} ")
    end
  end
  application.add_action(open_action)

  # File menu
  menu_model = Gio::Menu.new
  menu_model.append_submenu("File", file_menu)

  application.menubar = menu_model
  scrolled.set_child(view)
  window.set_child(scrolled)
  window.present
end

app.run
