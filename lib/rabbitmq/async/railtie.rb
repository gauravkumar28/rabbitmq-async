 require 'rails'
 require 'json'
 class Railtie < Rails::Railtie
    railtie_name :rabbitmq

    rake_tasks do
      namespace :rabbitmq do
        desc "consumers to perform async task"
        task :consumer => :environment do
          consumer_name = ENV["name"] || "generic"
          $consumer_config = YAML.load_file("#{Rails.root}/config/consumer.yml")
          conn = Bunny.new
          conn.start
          channel  = conn.create_channel
          exchange   = channel.topic($consumer_config["consumer"][consumer_name]["self_exchange"])
          queue   = channel.queue($consumer_config["consumer"][consumer_name]["queue"], :exclusive => true)

          queue.bind(exchange, :routing_key => $consumer_config["consumer"][consumer_name]["routing_key"])

          begin
            queue.subscribe(:block => true) do |delivery_info, properties, body|
             #parse msg and invoke method
             #puts "msg.......: #{body}"
             params = JSON.parse(body)
             #puts "params.......: #{params}"
             async_service = Rabbitmq::Async::Service.new(params)
             async_service.perform()
            end
          rescue Interrupt => _
            channel.close
            conn.close
          end
        end
      end

      task :rabbitmq => ['rabbitmq:consumer']
    end
  end