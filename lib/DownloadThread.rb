class DownloadThread < Thread

  @@instance = nil
  attr_accessor :sound_to_download

  def initialize
    @sound_to_download = Queue.new
    super()
    puts "used constructor"
  end

  def self.push(arg)
    puts "#{arg} pushed"
    if @@instance==nil
      @@instance = DownloadThread.new do
        # Thread.stop
        self.test1
        @@instance = nil
      end
    end
    @@instance.sound_to_download.push(arg)
  end

  def self.test1
    while @@instance.sound_to_download.size>0
      sleep 5
      puts @@instance.sound_to_download.pop
    end
  end

end
