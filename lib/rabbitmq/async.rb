require "rabbitmq/async/version"
require "rabbitmq/async/service"
require 'rabbitmq/async/initialize'
require 'rabbitmq/async/helpers/rabbitmq_helper'
require "rabbitmq/async/railtie" if defined?(Rails)
module Rabbitmq
  module Async
  end
end
