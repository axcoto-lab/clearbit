helpers do
  def css_url
    @css_url || "/css/app.css?t=#{File.mtime('./public/css/app.css').to_i}"
  end

  def js_url
    @js_url || "/js/app.js?t=#{File.mtime('./public/js/app.js').to_i}"
  end

  def bold(text)
    return "<strong>#{text}</strong>"
  end
end
