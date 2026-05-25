module FilePicker
  def self.open_file(window, &callback)
    dialog = Gtk::FileChooserDialog.new(
      title: "Open File",
      parent: window,
      action: :open
    )

    filter = Gtk::FileFilter.new
    filter.add_pattern("*.text")
    filter.add_pattern("*.txt")
    filter.add_pattern("*.rb")
    dialog.add_filter(filter)

    dialog.add_button("_Cancel", Gtk::ResponseType::CANCEL)
    dialog.add_button("_Open", Gtk::ResponseType::ACCEPT)
    dialog.modal = true
    dialog.signal_connect "response" do |d, response|
        if response == Gtk::ResponseType::ACCEPT
            file = d.file
            filename = file.path
            content = File.read(filename)
            callback.call(content, filename)
        end
        d.destroy
    end

    dialog.present
  end
end
