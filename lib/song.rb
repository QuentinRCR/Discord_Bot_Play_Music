class Song

  attr_accessor :url
  attr_accessor :absolut_path

  def initialize(url)
    @url=url
  end

  def download_song
    #defines the relative path to the downloads folder
    download_directory = File.join(File.expand_path('..', __dir__), 'downloads')
    puts("the path is #{download_directory}")


    #set the selenium driver with a defined profile
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["browser.helperApps.neverAsk.saveToDisk"] = 'audio/mpeg3,audio/x-mpeg-3,video/mpeg,video/x-mpeg' #never ask to save to disk those formats
    profile['browser.download.folderList'] = 2
    profile['browser.download.manager.showWhenStarting'] = false
    profile['browser.download.useDownloadDir'] = true
    profile['browser.download.dir'] = download_directory

    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    driver = Selenium::WebDriver.for :firefox, options: options
    driver.manage.timeouts.page_load = 30


    begin
      #get the video URL from youtube
      # query     = CGI.escape(song_name)
      # url       = "https://www.youtube.com/results?search_query=";
      # page      = driver.navigate.to (url + query)
      # ele       = driver.find_elements(:xpath, '//a[contains(@href, "watch?")]')[0]
      # @url = ele.attribute('href')
      # puts @url

      #tranform the youtube url to directly go to the mp3 downloader website
      driver.navigate.to(@url.gsub("youtube","youtubemz"))

      #wait for the download button to appear
      sleep 5

      #click on the button to download the video
      driver.find_element(:xpath,"/html/body/div[1]/section[1]/div/div[2]/div[2]/div/div[2]/div[2]/div[3]/table/tbody/tr[2]/td[3]/button[1]/a").click

      sleep 20 #wait for the end of the download

    #catch errors
    rescue => e
      p e.message
      sleep 6000 #sleep to have the time to debug
    end

    driver.quit #quit the diver
  end


end
