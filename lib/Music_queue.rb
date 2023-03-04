class MusicQueue < Queue #extend the queue library

  def initialize
    super
  end

  def push(song)
    super
  end

  def pop
    popped_song = super
    # popped_song.delete
    return popped_song
  end

end
