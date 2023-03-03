require 'discordrb'
require 'selenium-webdriver'
require_relative 'song'
require_relative 'bot'
require_relative 'bot_credentials'


# puts $LOAD_PATH

class Main


  def self.run
    bot_token= BOT_CREDENTIALS::INFO['token']
    client_id= BOT_CREDENTIALS::INFO['id']
    prefix="/"

    #create the discord bot
    bot=Bot.new(token: bot_token, client_id: client_id, prefix: prefix)


    #when the player executes the command /music
    bot.command :play do |event|
      url = event.message.content.gsub(prefix+"play", '') # Extract the URL from the message content
      song=Song.new(url)
      #song.download_song #download the sound
      voice_bot = bot.connect_user_voice_chanel(event) #Connect to the user channel
      puts "#{voice_bot}"
      if voice_bot!=nil #if the player was connected to a voice channel
        song.play(voice_bot,event) # Play the song
      end
    end

    bot.command :quit do |event|
      bot.quite_voice(event)
    end

    bot.command :stop do |event|
      bot.pause_voice(event)
    end
    #
    bot.command :resume do |event|
      bot.resume_voice(event)
    end

    bot.run(false) #run the bot forever
  end





Main.run

end
