#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'forking.rb'

f = Forking.new(:name => 'test',
    :working_dir => File.dirname(__FILE__),
    :log_file => "spawner.log", 
    :pid_file => "spawner.pid",
    :sync_log => true)

f.before_fork do
  puts "before fork"
end   
 
f.after_fork do
  puts "after fork"
end

2.times do |i|
  f.spawn(:name => "test1", :log_file => "test1.log") do
    $0 = "test1 #{i}"
    loop do
      puts "test1 #{i}"
      sleep 1
    end
  end
end

3.times do |i|
  f.spawn(:log_file => "test2.log", :sync_log => true) do
    exec 'ruby', '2.rb', '--test', 'some_value'
  end
end

f.run!
