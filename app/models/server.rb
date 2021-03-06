class Server < ApplicationRecord
  has_many :deployments, dependent: :destroy
  has_many :repositories, through: :deployments

  def to_json
    {
      id: id,
      ip: ip,
      name: name,
      description: description,
      detailUrl: "servers/#{id}",
      ping: ping
    }
  end

  def ping
    cmd = "ping -c 1 #{ip} | tail -1 | awk '{print $4}' | cut -d '/' -f 2"
    ping_response = %x(#{cmd}).strip
    return -1 if ping_response.include? "unknown host"
    ping_response.to_i
  end

  # TODO: move to deployment
  # def clean_url
  #   url.gsub(/http(s){0,1}:\/\//, '')
  # end

  def up?
    ping > 0
  end
end
