require 'rails_helper'

RSpec.describe Group, type: :model do
  before do
    @group = build(:group)
  end

  describe 'グループ新規登録' do
    context '新規登録がうまくいくとき' do
      it "nameが存在すれば登録できる" do
        expect(@group).to be_valid
      end
      it "nameが日本語で入力されても登録できる" do
        @group.name = "チャットグループ"
        expect(@group).to be_valid
      end
      it "nameが20文字以下だと登録できる" do
        @group.name = "a" * 20
        expect(@group).to be_valid
      end
      it "nameが重複していなければ登録できる" do
        another_group = create(:group, name: "test1")
        @group.name = "test2"
        expect(@group).to be_valid
      end
    end

    context '新規登録がうまくいかないとき' do
      it "nameが空だと登録できない" do
        @group.name = ''
        @group.valid?
        expect(@group.errors.full_messages).to include("Name can't be blank")
      end
      it "nameが21文字以上だと登録できない" do
        @group.name = 'a' * 21
        @group.valid?
        expect(@group.errors.full_messages).to include("Name is too long (maximum is 20 characters)")
      end
      it "nameが重複していると登録できない" do
        another_group = create(:group, name: "test")
        @group.name = 'test'
        @group.valid?
        expect(@group.errors.full_messages).to include("Name has already been taken")
      end
    end
  end
end
