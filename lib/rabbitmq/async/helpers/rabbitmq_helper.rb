require "bunny"

module RabbitmqHelper
  def publish_event(msg, exchange_name, routing_key)
    connection = Bunny.new
    connection.start

    channel  = connection.create_channel
    exchange = channel.topic(exchange_name, :auto_delete => true)
    exchange.publish(msg, :routing_key => routing_key)
    connection.close
  end
end