require 'rails_helper'

RSpec.describe "Api::V1::Messages", type: :request do
  let(:group) { create(:group) }

  before do
    @api_v1_group_messages_path_json = api_v1_group_messages_path(group) + '.json' # api/vi/messages#create用のURLを生成
  end

  describe 'メッセージ作成機能(api/v1/messages#create)' do
    let(:message) { create(:message) }

    subject { post @api_v1_group_messages_path_json, params: { message: @message_params } } # api/v1/messages#createへリクエストを送る

    context '新規作成に成功する場合' do
      before do
        @message_params = {content: message.content}
      end

      it 'ステータス200を返す' do
        subject
        expect(response.status).to eq(200)
      end

      it 'メッセージの数が+1される' do
        expect {subject}.to change(Message, :count).by(1)
      end
    end

    context '新規作成に失敗する場合' do
      context 'メッセージが空で入力された場合' do
        before do
          @message_params = {content: ''}
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end

        it 'メッセージの数が±0を返す' do
          expect {subject}.to change(Message, :count).by(0)
        end

        it 'エラーメッセージを返す' do
          expect(@json["errors"]).to include("メッセージ内容を入力してください")
        end
      end
    end
  end
end
