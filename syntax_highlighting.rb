module SyntaxHighlighting
  def syntax_highlight(buffer, filename)
    language_manager = GtkSource::LanguageManager.default

    language = language_manager.guess_language(filename, nil)

    if language
        buffer.language = language
        puts "language #{language.name}"
    else
        buffer.language = nil
        puts "no language detected."
    end
  end
end
