class MiniProcess
  attr_accessor :pid

  DEFAULT_SLEEP = 0.2

  # options
  #   :name         -
  #   :sleep        - timeout between spawns
  #   :log_file     -
  #   :sync_log     - 
  #   :working_dir  - for log
  #   :after_fork

  def initialize(opts = {}, &block)
    @opts = opts
    @block = block
    @opts[:sync_log] ||= true

    raise "block should be" unless block
  end

  def start    
    GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

    @pid = fork do
      STDIN.reopen("/dev/null")
      log_name = @opts[:log_file] || "/dev/null"
      log_name = File.expand_path(log_name)
      STDOUT.reopen(log_name, "a")
      STDOUT.sync = @opts[:sync_log]
      STDERR.reopen(log_name, "a")
      STDERR.sync = @opts[:sync_log]
      @opts[:after_fork].call if @opts[:after_fork]
      @block.call
    end

    puts "start process #{name}"
    pause
    @pid
  end

  def stop
    return unless @pid
    Process.kill("KILL", @pid) rescue nil
    puts "stop #{name}"
  end

  def pause
    sleep (@opts[:sleep] || DEFAULT_SLEEP).to_f
  end

  def name
    "#{@opts[:name]}[#{@pid}]"
  end  

end
