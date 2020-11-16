require 'rails_helper'

RSpec.describe "Api::V1::Groups", type: :request do

  before do
    @api_v1_groups_path_json = api_v1_groups_path + '.json'
  end

  describe 'グループ一覧機能(api/v1/groups#index)' do

    context 'グループの取得が成功する' do
      it '全てのグループを取得する' do
        create_list(:group, 10)
        # api/v1/groups#indexへリクエストを送る。
        get @api_v1_groups_path_json
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json.length).to eq(10)
      end
    end

    context 'グループの取得が失敗する' do
      it 'グループが存在しない場合はエラーメッセージを取得する' do
        # api/v1/groups#indexへリクエストを送る
        get @api_v1_groups_path_json
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["errors"]).to eq("グループが存在しません")
      end
    end
  end

  describe 'グループ作成機能(api/v1/groups#create)' do
    # 変数宣言
    let(:group) { build(:group) }
    # 変数としては使わないがレコードが欲しい、予めログインしておきたい等
    before do
      @another_group = create(:group)
    end

    context 'グループ新規作成が成功する' do
      it '新しいグループを作成する' do
        group_params = {name: group.name}
        # api/v1/groups#createへリクエストを送る
        expect { post @api_v1_groups_path_json, params: { group: group_params } }.to change(Group, :count).by(1)
        expect(response.status).to eq(200)
      end
    end

    context 'グループ新規作成が失敗する' do
      it 'グループ作成に失敗した場合はエラーメッセージを取得する(グループ名が空の場合)' do
        group_params = {name: ""}
        # api/v1/groups#createへリクエストを送る
        expect { post @api_v1_groups_path_json, params: { group: group_params } }.to change(Group, :count).by(0)
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["errors"]).to include("グループ名を入力してください")
      end

      it 'グループ作成に失敗した場合はエラーメッセージを取得する(グループ名が21文字以上の場合)' do
        group_params = {name: "a" * 21}
        # api/v1/groups#createへリクエストを送る
        expect { post @api_v1_groups_path_json, params: { group: group_params } }.to change(Group, :count).by(0)
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["errors"]).to include("グループ名は20文字以内で入力してください")
      end

      it 'グループ作成に失敗した場合はエラーメッセージを取得する(グループ名が重複の場合)' do
        group_params = {name: @another_group.name}
        # api/v1/groups#createへリクエストを送る
        expect { post @api_v1_groups_path_json, params: { group: group_params } }.to change(Group, :count).by(0)
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["errors"]).to include("グループ名はすでに存在します")
      end
    end
  end
end
