module Rabbitmq
  module Async
    class Service
      attr_reader :object, :method, :arg_list, :object_method, :klass

      def initialize(params)
        @object = params["object"] || (raise "Object Name Missing")
        @method = params["method"] || (raise "Method Name Missing")
        @arg_list = params["arg_list"] || (raise "Argument List Misisng")
        @object_method = params["object_method"] || false
        @klass = params["class"] || nil
        @arg_list = parse_arg(@arg_list)
      end

      def perform
        object_method ? perform_object_method : perform_class_method
      end

      def perform_class_method
        object.constantize.send(method.to_sym, *arg_list)
      end

      def perform_object_method
        obj = klass.constantize.send(:find, object["id"])
        obj.send(method.to_sym, *arg_list)
      end

      private 

      def parse_arg(arg_list)
        models = ActiveRecord::Base.subclasses.collect { |type| type.name }.sort
        new_arg_list = []
        arg_list.each do |arg|
          if arg.class == ActiveSupport::HashWithIndifferentAccess
            klass_key = arg.keys.first
            if models.include? klass_key
              #TODO  add validation for Hash of object
              if arg[klass_key].class == Array 
                new_arg_list << arg[klass_key].map{ |x| klass_key.constantize.find(x["id"])}
              else
                new_arg_list << klass_key.constantize.find(arg[klass_key]["id"])
              end
            else
              new_arg_list << arg
            end
          else
            new_arg_list << arg
          end
        end
        new_arg_list
      end
    end
  end
end