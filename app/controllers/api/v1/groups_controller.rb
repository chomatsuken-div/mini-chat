class Api::V1::GroupsController < ApplicationController
  def index
    groups = Group.order(created_at: :DESC)
    if groups.present?
      render json: groups, status: 200
    else
      render json: { errors: "グループが存在しません" }
    end
  end

  def create
    group = Group.new(group_params)
    if group.save
      render json: group, status: 200
    else
      render json: { errors: group.errors.full_messages }
    end
  end

  def update
  end

  private
    def group_params
      params.require(:group).permit(:name)
    end
end
