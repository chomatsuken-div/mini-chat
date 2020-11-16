require 'rails_helper'

RSpec.describe "Api::V1::Groups", type: :request do

  before do
    @api_v1_groups_path_json = api_v1_groups_path + '.json'
  end

  describe 'グループ一覧機能(api/v1/groups#index)' do

    context 'グループの取得が成功する' do
      it '全てのグループを取得する' do
        create_list(:group, 5)
        # api/v1/groups#indexへリクエストを送る。
        get @api_v1_groups_path_json
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json.length).to eq(5)
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
    let(:group) { build(:group) }

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

  describe 'グループ更新機能(api/v1/groups#update)' do
    let(:group) { create(:group) }

    before do
      @api_v1_group_path_json = api_v1_group_path(group.id) + '.json'
      @another_group = create(:group)
    end

    context 'グループ更新が成功する' do
      it 'グループ名変更に成功する' do
        group_params = {name: (group.name + 'test')}
        # api/v1/groups#updateへリクエストを送る
        patch @api_v1_group_path_json, params: { group: group_params }
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["name"]).to eq(group_params[:name])
      end
    end

    context 'グループ更新が失敗する' do
      it 'グループ更新に失敗した場合はエラーメッセージを取得する(グループ名が空の場合)' do
        group_params = {name: ""}
        # api/v1/groups#updateへリクエストを送る
        patch @api_v1_group_path_json, params: { group: group_params }
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["errors"]).to include("グループ名を入力してください")
      end

      it 'グループ更新に失敗した場合はエラーメッセージを取得する(グループ名が21文字以上の場合)' do
        group_params = {name: "a" * 21}
        # api/v1/groups#updateへリクエストを送る
        patch @api_v1_group_path_json, params: { group: group_params }
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["errors"]).to include("グループ名は20文字以内で入力してください")
      end

      it 'グループ更新に失敗した場合はエラーメッセージを取得する(グループ名が重複の場合)' do
        group_params = {name: @another_group.name}
        # api/v1/groups#updateへリクエストを送る
        patch @api_v1_group_path_json, params: { group: group_params }
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json["errors"]).to include("グループ名はすでに存在します")
      end
    end
  end
end
