class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel"
  end

  def unsubscribed
  end

  def speak(messageData)
    message = Message.new(content: messageData['content'], group_id: messageData['group_id'])
    message.save if message.valid?
    ActionCable.server.broadcast 'message_channel', message
  end
end
