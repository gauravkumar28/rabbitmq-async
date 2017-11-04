require "bunny"

module RabbitmqHelper
  def self.publish_event(msg, exchange_name, routing_key)
    connection = Bunny.new
    connection.start
    channel  = connection.create_channel
    exchange = channel.topic(exchange_name)
    exchange.publish(msg.to_json, :routing_key => routing_key)
    connection.close
  end
end