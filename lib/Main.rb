require 'discordrb'
require 'selenium-webdriver'
require "cgi"
require_relative 'song'
require_relative 'bot_credentials'



class Main


  def self.run
    bot_token= BOT_CREDENTIALS::INFO['token']
    client_id= BOT_CREDENTIALS::INFO['id']
    prefix="/"

    #create the discord bot
    bot=Discordrb::Commands::CommandBot.new(token: bot_token, client_id: client_id, prefix: prefix)
    bot.command :music do |event|
      # Extract the URL from the message content
      url = event.message.content.gsub(prefix+"music", '')
      event.respond("Ok, I'll play the song in this url #{url}")

      # Do something with the URL, such as printing it to the console
      puts "The URL is #{url}"
    end
    bot.run(false) #run the bot in-definitionally


    #song1= Song.new("https://www.youtube.com/watch?v=sUmVrPGYZ-E")
    #song1.absolut_path ="onlymp3.to - Hilda x Don Diablo - Wake Me When It's Quiet Lyric Video-sUmVrPGYZ-E-256k-1654729619195"
    #song1.download_song
  end



end

Main.run
