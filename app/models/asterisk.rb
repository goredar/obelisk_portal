class Asterisk
  def self.request
    ami = RubyAsterisk::AMI.new(ASTERISK_CONFIG["host"], ASTERISK_CONFIG["port"])
    ami.login(ASTERISK_CONFIG["username"], ASTERISK_CONFIG["password"])
    value = block_given? ? yield(ami) : nil
    ami.disconnect
    value
  end
  def self.call
  end
  def self.update_asterisk_peers_status
  end
  def self.get_peer_status(peer)
    request { |ami| ami.extension_state(peer, "from-internal").data.fetch(:hints).first.fetch("DescriptiveStatus") }
  end
end
