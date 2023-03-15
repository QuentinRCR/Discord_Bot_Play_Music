
class SongHandler
  # attr_accessor @songToDownload
  # attr_accessor @downloadedSongs
  attr_accessor :downloader_thread


  def initialize(voice_bot)
    @downloader_thread =Thread.new do
      while true
        Thread.stop
        self.test1
      end
    end
    # @player_thread =Thread.new do
    #   self.download_songs
    # end
    # @player_thread.join
    @song_to_download = Array.new
    @downloaded_songs = Array.new
    @voice_bot = voice_bot
  end

  def test1
    puts "start test1"
    sleep 3
    puts "end test1"
  end

  def play_song
    while @downloaded_songs.size >0
      song_to_p = @downloaded_songs.shift
      @voice_bot.play_file(song_to_p.absolut_path)
    end
  end

  def download_songs #function executed in // to download every song in order
    while @song_to_download.size > 0
      song_to_d =@song_to_download.shift
      song_to_d.download_song
      @downloaded_songs.push(song_to_d)
    end
  end

end
