class Bot < Discordrb::Commands::CommandBot #the < is the extend equivalent

  def initialize(attributes = nil)
    super
  end

  def connect_user_voice_chanel(event)
    # Check if the user is in a voice channel
    unless event.user.voice_channel
      event.respond "You need to join a voice channel first"
      return nil
    end

    # Join the user's voice channel
    self.voice_connect(event.user.voice_channel)

    # Get the voice bot instance
    voice_bot = self .voice(event.server)

    return  voice_bot
  end
end
