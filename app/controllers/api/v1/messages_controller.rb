class Api::V1::MessagesController < ApplicationController
  def create
    message = Group.find(params[:group_id]).messages.new(message_params)
    if message.save
      render json: message, status: 200
    else
      render json: { errors: message.errors.full_messages }
    end
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end
end
