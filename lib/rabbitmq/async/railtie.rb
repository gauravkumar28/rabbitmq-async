 require 'rails'
 class Railtie < Rails::Railtie
    railtie_name :rabbitmq

    rake_tasks do
      namespace :rabbitmq do
        desc "outdated"
        task :consumer => :environment do
          consumer = ENV["name"] || "generic"
          $consumer_config = YAML.load("config/consumer_config.yml")
          conn = Bunny.new
          conn.start
          channel  = conn.create_channel
          exchange   = channel.topic($consumer_config[consumer]["self_exchange"])
          queue   = channel.queue($consumer_config[consumer]["queue"], :exclusive => true)

          queue.bind(exchange, :routing_key => $consumer_config[consumer]["routing_key"])

          begin
            q.subscribe(:block => true) do |delivery_info, properties, body|
             #parse msg and invoke method
             params = JSON.parse(body)
             async_service = Rabbitmq::Async::Service.new(params)
             async_service.perform()
            end
          rescue Interrupt => _
            ch.close
            conn.close
          end
        end
      end

      task :rabbitmq => ['rabbitmq:consumer']
    end
  end