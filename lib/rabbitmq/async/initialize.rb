$consumer_config = YAML.load("config/consumer_config.yml")
ActiveRecord::Base.class_eval do
  def perform_async(method, *args)
    RabbitmqHelper.publish_event({"object" => self, "method" => method, "arg_list" => args, "object_method" => true, "class" => self.class.name}, $consumer_config["common"]["self_exchange"], $consumer_config["consumer"]["#{self.class.table_name.singularize }"]["routing_key"])
    self
  end

  def self.perform_async(method, *args)
    RabbitmqHelper.publish_event({"object" => self, "method" => method, "arg_list" => args}, $consumer_config["common"]["self_exchange"], $consumer_config["consumer"]["#{self.table_name.singularize}"]["routing_key"])
    self
  end
end
