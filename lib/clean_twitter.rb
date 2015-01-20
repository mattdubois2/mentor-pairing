module CleanTwitter
  def self.fix_handle(handle)
    handle.gsub!(/^@/, "")
    handle.gsub!(/^.*\/+/, "")
    handle
  end
end
