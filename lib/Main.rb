require 'discordrb'
require 'selenium-webdriver'
require_relative 'song'
require_relative 'bot_credentials'


# puts $LOAD_PATH

class Main


  def self.run
    bot_token= BOT_CREDENTIALS::INFO['token']
    client_id= BOT_CREDENTIALS::INFO['id']
    prefix="/"

    #create the discord bot
    bot=Discordrb::Commands::CommandBot.new(token: bot_token, client_id: client_id, prefix: prefix)


    #when the player executes the command /music
    bot.command :music do |event|
      url = event.message.content.gsub(prefix+"music", '') # Extract the URL from the message content
      song=Song.new(url)
      #song.download_song #download the sound
      voice_bot = connect_user_voice_chanel(event,bot) #Connect to the user channel
      if voice_bot!=nil #if the player was connected to a voice channel
        song.play(voice_bot,event) # Play the song
      end
    end

    bot.run(false) #run the bot forever
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
    voice_bot = bot.voice(event.server)

    return  voice_bot
  end



Main.run

end
