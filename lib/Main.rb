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
      # Check that the user is connected to a voice channel
      if event.user.voice_channel
        if url != nil
            event.respond "Ok I will play the song, please let me a few seconds to download it"
            DownloadThread.push(Song.new(url,"play"),event,bot)
        else
          event.respond "Please provide the URL of the music you want to play"
        end
      else
        event.respond "You need to join a voice channel first"
      end
      return nil #to avoid unwanted responses in the chat
    end

    bot.command :queue do |event,url|
      if url=="info"
        begin
          PlayMusicThread.queue_info(event)
        rescue NoMethodError => e
          event.respond "The queue is currently empty !"
        end
      elsif !event.user.voice_channel
        event.respond "You need to join a voice channel first"
      elsif url != nil
        event.respond "Ok I add this song to the queue"
        DownloadThread.push(Song.new(url,"queue"),event,bot)
      else
        event.respond "Please provide the URL of the music you want to add to the queue"
      end
      return nil #to avoid unwanted responses in the chat
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
    bot.command :quit do |event|
      begin
        PlayMusicThread.quit
        event.respond "Bye, hope to see you soon"
      rescue NoMethodError
        event.respond "I am not connected to a voice chanel"
      end
      return nil #to avoid unwanted responses in the chat
    end
    #
    #
    bot.command :stop do |event|
      begin
        PlayMusicThread.pause_song
        event.respond "The music is paused"
      rescue NoMethodError
        event.respond "A song need to be playing to use this command"
      end
      return nil #to avoid unwanted responses in the chat
    end


    bot.command :resume do |event|
      begin
        PlayMusicThread.resume_song
        event.respond "ok I resume the music"
      rescue NoMethodError
        event.respond "A song need to be playing to use this command"
      end
      return nil #to avoid unwanted responses in the chat
    end
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
    bot.command :skip do |event|
      begin
        PlayMusicThread.skip
        event.respond "Ok I'll skip this song"
      rescue NoMethodError
        event.respond "A song need to be playing to use this command"
      end
    end

    bot.run(false) #run the bot forever
  end





Main.run

end
