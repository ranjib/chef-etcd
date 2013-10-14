require 'chef/resource'

class Chef
  class  Resource

    class Etcd < Chef::Resource

      identity_attr :key
      state_attrs :value
      provides :etcd

      def initialize(name, run_context=nil)
        super
        @resource_name = :etcd
        @action = [:set]
        @allowed_actions.push(:test_and_set, :delete, :get, :wait, :set)
        @key = name
        @value = nil
        @prev_value = nil
        @ttl = nil
      end

      def key(arg=nil)
        set_or_return(:key, arg, :kind_of => String)
      end

      def value(arg=nil)
        set_or_return(:value, arg, :kind_of => String)
      end

      def prev_value(arg=nil)
        set_or_return(:prev_value, arg, :kind_of => String)
      end

      def ttl(arg=nil)
        set_or_return(:ttl, arg, :kind_of => String)
      end
    end
  end
end
