# RabbitmqAsync

rabbitmq-async is a rabbitmq-backed library for calling object(Class) methods asynchronously, placing those requests on multiple queues, and processing them in consumers.

Any Ruby class can call perform_async method to execute a method asynchronously

RabbitmqAsync is simillar to rescure

[Demo app using RabbitmqAsync]()

Say you have a ruby class
```ruby
class Order < ActiveRecord::Base

  def display id
    self.name
  end

  def self.list count
    Order.first(count).each do |x|
      x.name
    end
  end

  def update_name new_name
    self.name = new_name
    self.save
  end

  def self.create_order name
    order = Order.new
    order.name = name
    order.save!
  end

end
```

and you want to call create_order method asynchronously
```ruby
Order.perform_async("create_order", "xyz")
```
will do the job 

###Similarly to call update_name method asynchronously
```ruby
order.perform_async("update_name", "abc")
```
###Generic Call
```ruby
object.perform_async("<method_name">, <comma seperated arguments>)
```

###For example
```ruby
order.perform_async("notify_user", 1, "msg")
```
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rabbitmq-async'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rabbitmq-async

## Usage

Need to add consumer.yml in app/config to specify queue name, exchange and routing key
To deal with scalablity each class can have differnt queue
```ruby
consumer:
  user:
    routing_key: "myroute1"
    self_exchange: "selfexchange2"
    queue: "myqueue1"
  comment:
    routing_key: "myroute2"
    self_exchange: "selfexchange2"
    queue: "myqueue2"
  generic:
    routing_key: "myroute3"
    self_exchange: "selfexchange3"
    queue: "myqueue3"
  order:
    routing_key: "myroute4"
    self_exchange: "selfexchange4"
    queue: "myqueue4"
```

Need to start consumers which will perform the method execution
```ruby
rake rabbitmq:consumer name=order
```
here name is the class name, for which this consumer will perform the task

#### Demo use case


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rabbitmq-async. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rabbitmq::Async project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rabbitmq-async/blob/master/CODE_OF_CONDUCT.md).
