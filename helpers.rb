helpers do
  RECURRING_STOP_WORDS = ["Company Payroll", "recurring"]

  def css_url
    @css_url || "/css/app.css?t=#{File.mtime('./public/css/app.css').to_i}"
  end

  def js_url
    @js_url || "/js/app.js?t=#{File.mtime('./public/js/app.js').to_i}"
  end

  def bold(text)
    return "<strong>#{text}</strong>"
  end

  def transaction_type(statement)
    if RECURRING_STOP_WORDS.any? { |w| statement.name.downcase.include? w }
      "Recurring"
    else
      "Transaction"
    end
  end

  def transaction_status(statement)
    if statement.pending
      "Pending"
    else
      "Done"
    end
  end
end
