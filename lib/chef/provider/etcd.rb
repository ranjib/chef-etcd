require 'chef/provider'
require 'etcd'



class Chef
  class  Provider
    class Etcd < Chef::Provider

      def initialize(new_resource, run_context)
        super(new_resource, run_context)
      end

      def load_current_resource
        @current_resource ||= Chef::Resource::Etcd.new(new_resource.name)
        if key_exist?
          @current_resource.value(current_value)
        end
        @current_resource
      end

      def whyrun_supported?
        true
      end

      def config
        @config ||= Chef::Config[:etcd]
      end

      def etcd
        @etcd ||= ::Etcd.client(config)
      end


      def key_exist?
        exist = true
        begin
          etcd.get(new_resource.key)
        rescue Net::HTTPServerException => e
          exist = false
        end
        exist
      end

      def current_value
        if key_exist?
          etcd.get(new_resource.key).value
        else
          nil
        end
      end

      def action_set
        if @current_resource.value == new_resource.value
          Chef::Log.debug(" etcd #{new_resource.key} is in sync")
        else
          converge_by "will set value of key #{new_resource.key}" do
            etcd.set(new_resource.key, new_resource.value)
            new_resource.updated_by_last_action(true)
          end
        end
      end
      def action_get
        converge_by "will get value of key #{new_resource.key}" do
          if key_exist?
            current_value
          else
            nil
          end
          new_resource.updated_by_last_action(true)
        end
      end

      def action_test_and_set
        begin
          etcd.test_and_set(new_resource.key, new_resource.value, new_resource.prev_value, new_resource.ttl)
        rescue Net::HTTPServerException => e
          converge_by "will not be able test_and_set value of key #{new_resource.key}" do
            new_resource.updated_by_last_action(true)
          end
        end
      end

      def action_watch
        converge_bey "will wait for update from etcd key #{new_resource.key}" do
          etcd.watch(new_resource.key)
          new_resource.updated_by_last_action(true)
        end
      end

      def action_delete
        if key_exist?
          converge_by "will delete etcd key #{new_resource.key}" do
            etcd.delete(new_resource.key)
            new_resource.updated_by_last_action(true)
          end
        else
          Chef::Log.debug("etcd key #{new_resource.key} does not exist")
        end
      end
    end
  end
end

