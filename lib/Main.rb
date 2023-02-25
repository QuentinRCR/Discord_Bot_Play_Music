#require 'discordrb'
require 'selenium-webdriver'
require "cgi"



class Main

  def download_audio_with_url(video_url)
    #set the selenium driver with a defined profile
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["browser.download.folderList"] = 1
    profile["browser.helperApps.neverAsk.saveToDisk"] = 'audio/mpeg3,audio/x-mpeg-3,video/mpeg,video/x-mpeg'
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    driver = Selenium::WebDriver.for :firefox, options: options
    driver.manage.timeouts.page_load = 30


    begin
      #get the video URL from youtube

      # query     = CGI.escape(song_name)
      # url       = "https://www.youtube.com/results?search_query=";
      # page      = driver.navigate.to (url + query)
      # ele       = driver.find_elements(:xpath, '//a[contains(@href, "watch?")]')[0]
      # video_url = ele.attribute('href')
      # puts video_url





      #tranform the youtube url to directly go to the mp3 downloader website
      driver.navigate.to(video_url.gsub("youtube","youtubemz"))

      #wait for the download button to appear
      sleep 3

      #click on the button to download the video
      driver.find_element(:xpath,"/html/body/div[1]/section[1]/div/div[2]/div[2]/div/div[2]/div[2]/div[3]/table/tbody/tr[2]/td[3]/button[1]/a").click

      sleep 10 #wait for the end of the download

      #catch errors
    rescue => e
      p e.message
      sleep 6000 #sleep to have the time to debug
    end

    driver.quit

    driver.navigate.to(video_url.gsub("youtube","youtubemz"))
  end


  def self.run
    # bot_token="MTA3ODcwMzE1MDM3MTk3MTA4Mg.GzD8Wj.MQIdvJjY-WPxznk66l3ByRtuEQ1damI3L4RaKg"
    # client_id=1078703150371971082
    # prefix="/"
    #
    # #create the discord bot
    # bot=Discordrb::Commands::CommandBot.new(token: bot_token, client_id: client_id, prefix: prefix)
    # bot.command :music do |event|
    #   # Extract the URL from the message content
    #   url = event.message.content.gsub(prefix+"music", '')
    #
    #   # Do something with the URL, such as printing it to the console
    #   puts "The URL is #{url}"
    # end
    # bot.run(false) #run the bot in-definitionally

    #downloadAudioWithURL("https://www.youtube.com/watch?v=sUmVrPGYZ-E")
  end



end

main = Main.new
main.download_audio_with_url("https://www.youtube.com/watch?v=sUmVrPGYZ-E")
