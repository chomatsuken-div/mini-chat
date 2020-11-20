require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message) { build(:message) }

  describe 'メッセージ新規登録(api/v1/messages#create)' do
    context '新規登録が成功する場合' do
      it "contentが入力されている場合、バリデーションを通過する" do
        expect(message).to be_valid
      end
    end

    context '新規登録が失敗する場合' do
      it "contentが空の場合、エラーメッセージを返す" do
        message.content = ''
        message.valid?
        expect(message.errors.full_messages).to include("メッセージ内容を入力してください")
      end
    end
  end
end
