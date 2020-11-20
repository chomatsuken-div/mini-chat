class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel"
  end

  def unsubscribed
  end

  def speak(messageData)
    message = Message.new(content: messageData['content'], group_id: messageData['group_id'])

    # 将来的にMessageのバリデーションが追加された際の拡張性を踏まえ、以下の記述を実施（20201121時点ではバリデーションにかかることは無い）
    result_message = message.save ? {success: message} : {errors: "メッセージの送信に失敗しました"}
    ActionCable.server.broadcast 'message_channel', result_message
  end
end
