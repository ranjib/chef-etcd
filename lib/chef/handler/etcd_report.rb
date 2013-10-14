require 'chef/handler'
require 'etcd'
require 'json'

class Chef
  class Handler
    class EtcdReport < Chef::Handler

      attr_reader :etcd

      def initialize(options={})
        @etcd = ::Etcd.client(options)
      end

      def report
        if success?
          data = {total: all_resources.size, updated: updated_resources.size, time: elapsed_time}
          @etcd.set('/nodes/'+Chef::Config[:node_name]+'/chef/report',JSON.dump(data)
        end
      end
    end
  end
end
