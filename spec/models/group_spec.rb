require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { build(:group) }

  before do
    @another_group = create(:group)
  end

  describe 'グループ新規登録(api/v1/groups#create)' do
    context '新規登録が成功する場合' do
      it "nameが入力されている場合、バリデーションを通過する" do
        expect(group).to be_valid
      end
      it "nameが日本語で入力されている場合、バリデーションを通過する" do
        group.name = "チャットグループ"
        expect(group).to be_valid
      end
      it "nameが20文字以下で入力されている場合、バリデーションを通過する" do
        group.name = "a" * 20
        expect(group).to be_valid
      end
      it "nameが重複していない場合、バリデーションを通過する" do
        create(:group, name: "test1")
        group.name = "test2"
        expect(group).to be_valid
      end
    end

    context '新規登録が失敗する場合' do
      it "nameが空の場合、エラーメッセージを返す" do
        group.name = ''
        group.valid?
        expect(group.errors.full_messages).to include("グループ名を入力してください")
      end
      it "nameが21文字以上の場合、エラーメッセージを返す" do
        group.name = 'a' * 21
        group.valid?
        expect(group.errors.full_messages).to include("グループ名は20文字以内で入力してください")
      end
      it "nameが重複している場合、エラーメッセージを返す" do
        group.name = @another_group.name
        group.valid?
        expect(group.errors.full_messages).to include("グループ名はすでに存在します")
      end
    end
  end
end
