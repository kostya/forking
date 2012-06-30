require File.join(File.dirname(__FILE__), 'daemon_spawn_base')
require File.join(File.dirname(__FILE__), 'mini_process')

class Forking

  # opts:
  #   :name
  #   :sync_log
  #   :log_file
  #   :pid_file
  #   :working_dir *

  def initialize(opts = {})
    @opts = opts
    @merge_opts = opts.update(:sync_log => nil) # sync_log should specify for each spawn
    @procs = []    
  end  

  def run!
    $0 = "#{@opts[:name]} spawner" unless @opts[:dont_touch_pl]
    DaemonSpawnBase.spawn!(@opts.merge(:procs => @procs, :before_fork => @before_fork, :application => @opts[:name]))
  end

  def spawn(opts = {}, &block)
    @procs << MiniProcess.new(@merge_opts.merge(opts).merge(:after_fork => @after_fork), &block)
  end
  
  def before_fork(&block)
    @before_fork = block
  end
  
  def after_fork(&block)
    @after_fork = block
  end

end
