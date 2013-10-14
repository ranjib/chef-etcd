# Chef::Etcd

Provides chef resource/provider to access etcd key value pairs and report/event handlers to publish chef run data into etcd.

## Installation

Add this line to your application's Gemfile:

    gem 'chef-etcd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-etcd

## Usage

1. ```require``` the chef-etcd library in your client config (knife.rb/solo.rb/client.rb) and set ```Chef::Config[:etcd]``` to an existing [etcd](https://github.com/coreos/etcd) node.

```ruby
require 'chef/etcd'
node_name 'something'
etcd_host = '192.168.122.1'
Chef::Config[:etcd]= {host:etcd_host}
```

2. you can use the resource/provider to get/set etcd keys

```ruby
etcd "/test/recipe/set" do
  action :set
  value Time.now.to_s
end

etcd "/test/recipe/delete" do
  action :set
  value Time.now.to_s
end

etcd "/test/recipe/delete" do
  action :delete
  value Time.now.to_s
end

etcd "/test/recipe/test_and_set" do
  action :set
  value "0"
end

etcd "/test/recipe/test_and_set" do
  action :test_and_set
  value Time.now.to_s
  prev_value "0"
end

etcd "/test/recipe/watch" do
  action :set
  value Time.now.to_s
end

Chef::Log.warn("This will halt the recipe, and you have to update the recipe from outside or do some thread foo here")
etcd "/test/recipe/watch" do
  action :watch
  value Time.now.to_s
end

```
3. To publish node data using the report handler, or to monitor realtime chef resource convergence(event handler), add following configurations to your client.rb/solo.rb

```ruby
event_handlers [Chef::EventDispatch::Etcd.new(host: etcd_host)]
report_handlers << Chef::Handler::EtcdReport.new(host: etcd_host)

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
