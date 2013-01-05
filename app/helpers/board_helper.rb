module BoardHelper
  URL_CONFIG_FILE = Rails.root.join('config/url.conf')

  def self.app_url(request)
    configured_url || url_from_ip(request)
  end

private

  def self.configured_url
    url = File.exists?(URL_CONFIG_FILE) && File.read(URL_CONFIG_FILE)

    url.present? && url
  end

  def self.url_from_ip(request)
    base = "http://#{local_ip}"
    port = request.port
    base += ":#{port}" unless 80 == port
  end

  def self.local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
end