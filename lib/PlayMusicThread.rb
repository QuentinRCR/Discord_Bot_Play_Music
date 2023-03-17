class PlayMusicThread < Thread

  @@instance = nil
  attr_accessor :sound_to_play
  attr_accessor :voice_bot

  def initialize
    @sound_to_play = Array.new
    super()
    puts "used constructor"
  end

  def self.push(song,event,bot)
    puts "#{song} pushed"
    if @@instance==nil
      @@instance = PlayMusicThread.new do
        self.play_song(event,bot)
        @@instance = nil
      end
    end
    if song.add_to == "play"
      @@instance.sound_to_play.unshift(song) #add the song as the beginning of the array
      if @voice_bot!=nil
        @voice_bot.stop_playing #skip the currently playing song to start the one that was juste pushed
      end
    else
        @@instance.sound_to_play.push(song) #if the song was queue, add it the the end of the queue
    end
  end

  def self.play_song(event,bot)
    @voice_bot = self.connect_user_voice_chanel(event,bot)
    while @@instance.sound_to_play.size>0
      song=@@instance.sound_to_play.shift #remove the first element of the array and return it
      begin
        @voice_bot.play_file(song.absolut_path) #play it
        song.delete #once it is played, delete it from the downloaded files
      rescue => e
        event.respond("an error in voice_bot.play_file occurred: #{e}")
      end
    end
    if @voice_bot!=nil #if voice_bot is nil, it means that he channel was already forcibly quit
      self.quit #if there is no music left to play, it automatically disconnect
    end
  end

  def self.connect_user_voice_chanel(event,bot)
    # Check if the user is in a voice channel
    unless event.user.voice_channel
      event.respond "You need to join a voice channel first"
      return nil
    end

    # Join the user's voice channel
    bot.voice_connect(event.user.voice_channel)

    # Get the voice bot instance
    @voice_bot = bot.voice(event.server)

    return  @voice_bot
  end

  def self.skip
    @voice_bot.stop_playing
  end

  def self.pause_song
    @voice_bot.pause
  end

  def self.resume_song
    @voice_bot.continue
  end

  def self.quit
    @voice_bot.continue #in case the song was paused before, so that it frees the Thread
    @voice_bot.destroy #to leave the voice channel
    @@instance.sound_to_play.clear #clear the queue
    FileUtils.rm_rf("#{Dir.pwd}/downloads") #delete all potential remaining files downloaded
    @voice_bot=nil
  end

end
