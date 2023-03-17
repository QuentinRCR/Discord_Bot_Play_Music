require 'safe_shell'

class Song

  attr_accessor :url
  attr_accessor :absolut_path
  attr_accessor :title
  @@counter = 0 #declare variable as static
  attr_reader :id
  attr_reader :downloaded
  attr_accessor :add_to #stores the fact that the song need to be play or queued

  def initialize(url,add_to)
    @url=url
    @id = @@counter
    @@counter += 1
    @downloaded = false
    @add_to = add_to
  end

  def download_song
    @absolut_path="#{Dir.pwd}/downloads/#{@id}.mp3"
    begin
      #download the music to the path provided
      @title =JSON.parse( %x(python -m yt_dlp --print-json -f "ba" -x --audio-format mp3 #{url}  -o #{@absolut_path}))["title"]
      puts @title
    rescue => e
      puts "an error occurred during the song download. #{e}"
      return 1
    end

    @downloaded = true

    return 0
  end

  def delete
    @title=nil
    @url= nil
    File.delete(@absolut_path)
    @absolut_path = nil
    @id=nil
    # @@counter-=1 #do not put this counter as ot creates issues
  end


end
