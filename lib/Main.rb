require 'discordrb'
require_relative 'song'
require_relative 'bot'
require_relative 'bot_credentials'
require_relative 'Music_queue'

class Main

  def self.run
    FileUtils.rm_r("#{Dir.pwd}/downloads",secure: true) #delete all potential remaining files in the download directory
    #this a there to avoid useless songs taking memory if there are not deleted automatically

    bot_token= BOT_CREDENTIALS::INFO['token']
    client_id= BOT_CREDENTIALS::INFO['id']
    prefix="/"

    #create the discord bot
    bot=Bot.new(token: bot_token, client_id: client_id, prefix: prefix)


    #when the player executes the command /music
    bot.command :play do |event,url|
      begin
        voice_bot = bot.connect_user_voice_chanel(event) #Connect to the user channel

        if voice_bot!=nil #if the player was connected to a voice channel


          # add the sound to the queue
          bot.queue.push(Song.new(url))

          bot.play(event) #ask the bot to play the entire queue
        end


      rescue => e
        if e.exception.to_s.include?("Shell command [\"python")
          event.respond("Please provide a valid URL")
        else
          event.respond("An unexpected error occurred. The error was: #{e}")
        end

      end

      return nil #to avoid unwanted responses in the chat
    end


    bot.command :quit do |event|
      bot.quite_voice(event)
    end


    bot.command :stop do |event|
      bot.pause_voice(event)
      return nil #to avoid unwanted responses in the chat
    end


    bot.command :resume do |event|
      bot.resume_voice(event)
      return nil #to avoid unwanted responses in the chat
    end

    bot.command :queue do |event,url|
      puts "#{bot.voice_bot}"
      if bot.voice_bot != nil
        event.respond("#{url} was added to the queue")
        bot.queue.push(Song.new(url))
      else
        event.respond("Please use the `/play url` command to start the voice bot")
      end
      return nil #to avoid unwanted responses in the chat
    end

    bot.run(false) #run the bot forever
  end





Main.run

end
