require_relative 'PlayMusicThread'

class DownloadThread < Thread

  @@instance = nil
  attr_accessor :sound_to_download

  def initialize
    @sound_to_download = Queue.new
    super()
    puts "used constructor"
  end

  def self.push(song,event,bot)
    puts "#{song} pushed"
    if @@instance==nil
      @@instance = DownloadThread.new do
        self.downloadSong(event,bot)
        @@instance = nil
      end
    end
    @@instance.sound_to_download.push(song)
  end

  def self.downloadSong(event,bot)
    while @@instance.sound_to_download.size>0
      song=@@instance.sound_to_download.pop
      puts "downloading #{song.url}"
      song.download_song
      PlayMusicThread.push(song,event,bot)
    end
  end

end
