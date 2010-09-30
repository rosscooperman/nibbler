module FlashMessages

protected
  def flash_message(page, message, *values)
    flash_type, message = extract_flash_message(page, message, *values)
    flash[flash_type] = message
  end

  def flash_message_now(page, message, *values)
    flash_type, message = extract_flash_message(page, message, *values)
    flash.now[flash_type] = message
  end

  def extract_flash_message(page, message_type, *values)
    message = flash_messages_from_yaml[page] && flash_messages_from_yaml[page][message_type]
    raise "Unknown flash message specified: #{page}/#{message_type}" if message.nil?
    flash_type = :notice

    if message.is_a?(Hash)
      flash_type = message.keys.first
      message = message.values.first
    end

    [flash_type, sprintf(message, *values)]
  end

  def flash_messages_from_yaml
    @flash_messages_from_yaml ||= YAML.load_file(File.join(RAILS.root, "lib", "flash_messages.yml")).recursively_symbolize_keys
  end
end