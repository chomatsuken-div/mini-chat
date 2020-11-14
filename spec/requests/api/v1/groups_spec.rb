require 'rails_helper'

describe 'グループ一覧機能(api/v1/groups#index)' do
  context 'グループの取得が成功する' do
    it '全てのグループを取得する' do
      create_list(:group, 10)
      # api/v1/groups#indexへリクエストを送る。
      get '/api/v1/groups.json'
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end
  end

  context 'グループの取得が失敗する' do
    it 'グループが存在しない場合はエラーメッセージを取得する' do
      # api/v1/groups#indexへリクエストを送る
      get '/api/v1/groups.json'
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["errors"]).to eq("グループが存在しません")
    end
  end
end
