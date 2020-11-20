class Api::V1::GroupsController < ApplicationController
  before_action :set_groups, only: [:index]
  before_action :set_group, only: [:update, :destroy]
  
  def index
    if @groups.present?
      render json: @groups, status: 200
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
    if @group.update(group_params)
      render json: @group, status: 200
    else
      render json: { errors: @group.errors.full_messages }
    end
  end

  def destroy
    if @group.destroy
      render json: { status: 200 }
    else
      render json: { errors: "グループの削除に失敗しました" }
    end
  end

  private
    def group_params
      params.require(:group).permit(:name)
    end

    def set_group
      @group = Group.find(params[:id])
    end

    def set_groups
      @groups = []
      groups = Group.order(created_at: :DESC)
      groups.each do |group|
        messages = group.messages
        group_hash = group.attributes
        group_hash[:messages] = messages
        @groups << group_hash
      end
    end
end
