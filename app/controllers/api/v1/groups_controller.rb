class Api::V1::GroupsController < ApplicationController
  def create
    group = Group.new(group_params)
    if group.save
      render json: group, status: 200
    else
      render json: { errors: group.errors.full_messages }
    end
  end

  private
    def group_params
      params.require(:group).permit(:name)
    end
end
