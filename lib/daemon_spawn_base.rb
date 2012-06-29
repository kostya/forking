require 'daemon_spawn' # gem

class DaemonSpawnBase < DaemonSpawn::Base

  def initialize(args)
    GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)
    @args = args
    @procs = @args[:procs]
    @restart = true        

    super
  end

  def start(_)
    raise "empty @procs" if !@procs || @procs.empty?

    # HUP is restart all childs
    trap("HUP") do
      stop_all
    end
    
    @args[:before_fork].call if @args[:before_fork]

    start_all

    while @restart
      pid = nil
      
      begin  
        pid = Process.wait
      rescue Errno::ECHILD
      end
      
      process = @procs.detect{|p| p.pid == pid }
      puts "#{process.name} had just died!"

      process.start if @restart
    end
    
  rescue
    stop_all
  end

  def stop
    @restart = false
    stop_all
  end

private

  def start_all
    @procs.each do |process|
      process.start
    end

    puts "started all (#{@procs.size})!"
  end

  def stop_all
    return unless @procs

    @procs.each do |process|
      process.stop
    end

    puts "stopped all (#{@procs.size})!"
  end

end
