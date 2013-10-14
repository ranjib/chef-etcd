require 'chef/event_dispatch/base'
require 'etcd'

class Chef
  module EventDispatch
    class Etcd < Chef::EventDispatch::Base

      attr_reader :etcd

      def initialize(options={})
        etcd_host = options[:host] || '127.0.0.1'
        etcd_port = options[:port] || 4001
        @etcd = ::Etcd.client(host: etcd_host, port: etcd_port)
        @global_ttl = options[:global_ttl] || 600
        @ttls = options[:ttls] || {}
      end

      def get_ttl(m)
        if @ttls.has_key?(m)
          @ttls[m]
        else
          @global_ttl
        end
      end

      def name_space 
        '/nodes/' + Chef::Config[:node_name] + '/chef'
      end

      def etcd_set(m, k, v=nil) # m = method
        key= name_space + k 
        value = v || m
        ttl = get_ttl(m)
        etcd.set(key, value, ttl)
      end

      def set_sub_status(m)
       etcd_set(m, '/sub_status')
      end

      def run_start(version)
        etcd_set(__method__, '/status', 'running')
        etcd_set(__method__, '/version', version)
      end

      def run_completed(node)
        etcd_set(__method__, '/status', 'completed')
      end

      def run_failed(exception)
        etcd_set(__method__, '/status', 'failed')
      end

      def run_started(run_status)
        set_sub_status(__method__)
      end


      def ohai_completed(node)
        set_sub_status(__method__)
      end

      def skipping_registration(node_name, config)
        set_sub_status(__method__)
      end

      def registration_start(node_name, config)
        set_sub_status(__method__)
      end

      def registration_completed
        set_sub_status(__method__)
      end

      def registration_failed(node_name, exception, config)
        set_sub_status(__method__)
      end

      def node_load_start(node_name, config)
        set_sub_status(__method__)
      end

      def node_load_failed(node_name, exception, config)
        set_sub_status(__method__)
      end

      def run_list_expand_failed(node, exception)
        set_sub_status(__method__)
      end

      def node_load_completed(node, expanded_run_list, config)
        set_sub_status(__method__)
      end

      def cookbook_resolution_start(expanded_run_list)
        set_sub_status(__method__)
      end

      def cookbook_resolution_failed(expanded_run_list, exception)
        set_sub_status(__method__)
      end

      def cookbook_resolution_complete(cookbook_collection)
        set_sub_status(__method__)
      end

      def cookbook_clean_start
        set_sub_status(__method__)
      end

      def cookbook_clean_complete
        set_sub_status(__method__)
      end

      def cookbook_sync_start(cookbook_count)
        set_sub_status(__method__)
      end

      def cookbook_sync_failed(cookbooks, exception)
        set_sub_status(__method__)
      end

      def cookbook_sync_complete
        set_sub_status(__method__)
      end

      def library_load_start(file_count)
        set_sub_status(__method__)
      end

      def library_file_load_failed(path, exception)
        set_sub_status(__method__)
      end

      def library_load_complete
        set_sub_status(__method__)
      end

      def lwrp_load_start(lwrp_file_count)
        set_sub_status(__method__)
      end

      def lwrp_file_load_failed(path, exception)
        set_sub_status(__method__)
      end

      def lwrp_load_complete
        set_sub_status(__method__)
      end

      def attribute_load_start(attribute_file_count)
        set_sub_status(__method__)
      end

      def attribute_file_load_failed(path, exception)
        set_sub_status(__method__)
      end

      def attribute_load_complete
        set_sub_status(__method__)
      end

      def definition_load_start(definition_file_count)
        set_sub_status(__method__)
      end

      def definition_file_load_failed(path, exception)
        set_sub_status(__method__)
      end

      def definition_load_complete
        set_sub_status(__method__)
      end

      def recipe_load_start(recipe_count)
        set_sub_status(__method__)
      end

      def recipe_file_load_failed(path, exception)
        set_sub_status(__method__)
      end

      def recipe_not_found(exception)
        set_sub_status(__method__)
      end

      def recipe_load_complete
        set_sub_status(__method__)
      end

      def converge_start(run_context)
        set_sub_status(__method__)
      end

      def converge_complete
        set_sub_status(__method__)
      end

      def resource_action_start(resource, action, notification_type=nil, notifier=nil)
        etcd_set(__method__, '/resource_state', 'action_start')
        etcd_set(__method__, '/resource_name', resource.to_s)
        etcd_set(__method__, '/resource_action', action.to_s)
      end

      def resource_failed(resource, action, exception)
        etcd_set(__method__, '/resource_state', 'failed')
        etcd_set(__method__, '/resource_name', resource.to_s)
        etcd_set(__method__, '/resource_action', action.to_s)
      end

      def resource_completed(resource)
        etcd_set(__method__, '/resource_state', 'completed')
        etcd_set(__method__, '/resource_name', resource.to_s)
      end

      def resource_skipped(resource, action, conditional)
        etcd_set(__method__, '/resource_state', 'skipped')
        etcd_set(__method__, '/resource_name', resource.to_s)
        etcd_set(__method__, '/resource_action', action.to_s)
      end

      def resource_bypassed(resource, action, current_resource)
        etcd_set(__method__, '/resource_state', 'bypassed')
        etcd_set(__method__, '/resource_name', resource.to_s)
        etcd_set(__method__, '/resource_action', action.to_s)
      end

      def resource_up_to_date(resource, action)
        etcd_set(__method__, '/resource_state', 'converged')
        etcd_set(__method__, '/resource_name', resource.to_s)
        etcd_set(__method__, '/resource_action', action.to_s)
      end


      def resource_updated(resource, action)
        etcd_set(__method__, '/resource_state', 'updated')
        etcd_set(__method__, '/resource_name', resource.to_s)
        etcd_set(__method__, '/resource_action', action.to_s)
      end

      def handlers_start(handler_count)
        set_sub_status(__method__)
      end

      def handlers_completed
        set_sub_status(__method__)
      end

      def msg(message)
      end
    end
  end
end
