Forking
=======

Simple processes forking, and restarting. Master process starts as daemon.


    $ gem install forking


Example 1.rb (run 5 child processes and capturing logs):

```ruby
#!/usr/bin/env ruby
require 'rubygems'
require 'forking'

f = Forking.new(:name => 'test', :working_dir => File.dirname(__FILE__),
    :log_file => "spawner.log", :pid_file => "spawner.pid", :sync_log => true)

f.before_fork do
  puts "load env"
end

f.after_fork do
  puts "restart connects"
end

2.times do |i|
  f.spawn(:name => "test1", :log_file => "test1.log") do
    loop do
      puts "test1 #{i}"
      sleep 1
    end
  end
end

3.times do |i|
  f.spawn(:log_file => "test2.log", :sync_log => true) do
    exec 'ruby', '2.rb', '--test'
  end
end

f.run!
```

Usage:

    $ ./1.rb start
    $ ./1.rb status
    $ ./1.rb stop
    $ ./1.rb restart

Respawn childs:

    $ kill -HUP master_pid 
    