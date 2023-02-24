require 'discordrb'

class Main

  def self.run
    bot_token="MTA3ODcwMzE1MDM3MTk3MTA4Mg.GzD8Wj.MQIdvJjY-WPxznk66l3ByRtuEQ1damI3L4RaKg"
    client_id=1078703150371971082
    prefix="/"

    #create the discord bot
    bot=Discordrb::Commands::CommandBot.new(token: bot_token, client_id: client_id, prefix: prefix)
    bot.command :music do |event|
      # Extract the URL from the message content
      url = event.message.content.gsub(prefix+"music", '')

      # Do something with the URL, such as printing it to the console
      puts "The URL is #{url}"
    end
    bot.run(false) #run the bot in-definitionally
  end



end

Main.run
