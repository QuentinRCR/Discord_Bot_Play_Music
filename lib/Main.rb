require 'discordrb'
require_relative 'song'
require_relative 'bot'
require_relative 'bot_credentials'
require_relative 'SongHandler'
require_relative 'DownloadThread'


class Main

  def self.run

    bot_token= BOT_CREDENTIALS::INFO['token']
    client_id= BOT_CREDENTIALS::INFO['id']
    prefix="/"

    #create the discord bot
    bot=Bot.new(token: bot_token, client_id: client_id, prefix: prefix)

    # song_handler=SongHandler.new("hul")

    bot.command :play do |event,url|
      DownloadThread.push("#{url}")
    end


    # #when the player executes the command /music
    # bot.command :play do |event,url|
    #
    #   voice_bot = bot.connect_user_voice_chanel(event) #Connect to the user channel
    #
    #   if voice_bot!=nil #if the player was connected to a voice channel
    #
    #
    #     # add the sound to the queue
    #     new_song = Song.new(url)
    #     bot.queue.push(new_song)
    #     new_song.download_song
    #
    #     bot.play(event) #ask the bot to play the entire queue
    #   end
    #
    #
    #   return nil #to avoid unwanted responses in the chat
    # end
    #
    #
    # bot.command :quit do |event|
    #   bot.force_quit(event)
    # end
    #
    #
    # bot.command :stop do |event|
    #   bot.pause_voice(event)
    #   return nil #to avoid unwanted responses in the chat
    # end
    #
    #
    # bot.command :resume do |event|
    #   bot.resume_voice(event)
    #   return nil #to avoid unwanted responses in the chat
    # end
    #
    # bot.command :queue do |event,url|
    #
    #   if bot.voice_bot != nil #if a bot already exist
    #     new_song = Song.new(url)
    #     bot.queue.push(new_song)
    #
    #     #check that song before on the queue are downloaded before downloading
    #     bot.queue.each do |song|
    #       if song != new_song #if it reaches new_song, it means that all the previous song are downloaded
    #
    #         # check that the song still exit in the list (it could have been deleted in another thread)
    #         # Test if the song before is downloaded
    #           until bot.queue.include?(song) && bot.queue.select { |elem|  elem.url==song.url}[0].downloaded do
    #             sleep(5) #wait for the sound to be downloaded
    #             puts "wait for previous song to be downloaded"
    #           end
    #       end
    #     end
    #
    #     result=new_song.download_song
    #     if result==1 #if there is an error in the download
    #       event.respond("#{url} in not a valid URL")
    #       bot.queue.delete(new_song) #delete the song that was added but that can't be found
    #     else
    #       event.respond("#{url} was added to the queue") #after the download to make sure that the download works
    #     end
    #   else
    #     event.respond("Please use the `/play url` command to start the voice bot")
    #   end
    # end
    #
    # bot.command :skip do |event|
    #   event.respond "Ok I'll skip this song"
    #   bot.voice_bot.stop_playing
    # end

    bot.run(false) #run the bot forever
  end





Main.run

end
