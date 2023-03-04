class Song

  attr_accessor :url
  attr_accessor :absolut_path
  attr_accessor :title

  def initialize(url)
    @url=url
  end

  def download_song
    #get the title of the music
    @title = %x(python -m yt_dlp --skip-download --get-title #{url})


    title=@title.gsub(/[^0-9a-z ]/i,'') #keep only letters and figures
    title=title.gsub(/\s+/, '_') #replace all the spaces by _


    #download the music to the path provided
    %x(python -m yt_dlp -f "ba" -x --audio-format mp3 #{url}  -o #{Dir.pwd}/downloads/#{title})


    @absolut_path="#{Dir.pwd}/downloads/#{title}.mp3"
  end


    def play(voice_bot,event)
      # Send a message indicating that the song is playing
      event.respond "Playing #{url}"

      puts @absolut_path
      voice_bot.play_file(@absolut_path)


  end


end
