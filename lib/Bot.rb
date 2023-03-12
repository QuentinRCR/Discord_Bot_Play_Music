class Bot < Discordrb::Commands::CommandBot #the < is the extend equivalent

  attr_accessor :voice_bot
  attr_accessor :queue

  def initialize(attributes = nil)
    super
    @queue = Array.new
    @voice_bot = nil
  end

  def connect_user_voice_chanel(event)
    # Check if the user is in a voice channel
    unless event.user.voice_channel
      event.respond "You need to join a voice channel first"
      return nil
    end

    # Join the user's voice channel
    self.voice_connect(event.user.voice_channel)

    # Get the voice bot instance
    @voice_bot = self .voice(event.server)

    return  @voice_bot
  end

  def quite_voice(event)
    event.respond "Bye, hope to see you soon"
    @voice_bot.destroy
    @voice_bot = nil #because it is destroyed
    FileUtils.rm_rf("#{Dir.pwd}/downloads") #delete all potential remaining files downloaded
    return nil
  end

  def pause_voice(event)
    event.respond "The music is paused"
    @voice_bot.pause
  end

  def resume_voice(event)
    event.respond "ok I resume the music"
    @voice_bot.continue
  end

  def play(event)
    while @queue.size > 0
      until @queue[0].downloaded #check if the song on the updated queue is downloaded
        event.respond "Please wait for the song to download"
        sleep(5) #wait for the sound to be downloaded
      end
      song = @queue.pop
      puts song.absolut_path
      @voice_bot.play_file(song.absolut_path) #play it
      song.delete #once it is played, delete it from the downloads
    end
    self.quite_voice(event) #if there is no music left to play, it automatically disconnect
  end
end
