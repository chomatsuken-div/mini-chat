require 'rails_helper'

RSpec.describe "Api::V1::Groups", type: :request do
  before do
    @api_v1_groups_path_json = api_v1_groups_path + '.json' # api/vi/groups#index,create用のURLを生成
  end

  describe 'グループ一覧機能(api/v1/groups#index)' do
    subject {get @api_v1_groups_path_json} # api/v1/groups#indexへリクエストを送る
  
    context '全データ取得に成功する場合' do
      before do
        create_list(:group, 5)
        subject
        @json = JSON.parse(response.body)
      end

      it 'ステータス200を返す' do
        expect(response.status).to eq(200)
      end

      it '全グループ数を返す' do
        expect(@json.length).to eq(5)
      end
    end

    context '全データ取得に失敗する場合' do
      before do
        subject
        @json = JSON.parse(response.body)
      end

      it 'ステータス200を返す' do
        expect(response.status).to eq(200)
      end

      it 'グループが存在しない場合、エラーメッセージを返す' do
        expect(@json["errors"]).to eq("グループが存在しません")
      end
    end

    describe 'グループに紐づいているメッセージ取得確認' do
      let(:group) { create(:group) }

      context 'グループにメッセージが紐づいている場合' do
        before do
          create_list(:message, 5, group_id: group.id)
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end
  
        it 'グループに紐づいているメッセージの数を返す' do
          expect(@json[0]["messages"].length).to eq(5)
        end
      end
  
      context 'グループにメッセージが紐づいていない場合' do
        before do
          create(:group)
          subject
          @json = JSON.parse(response.body)
        end
  
        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end
  
        it 'グループが存在しない場合、エラーメッセージを返す' do
          expect(@json[0]["messages"].length).to eq(0)
        end
      end
    end
  end

  describe 'グループ作成機能(api/v1/groups#create)' do
    let(:group) { build(:group) }

    subject { post @api_v1_groups_path_json, params: { group: @group_params } } # api/v1/groups#createへリクエストを送る

    context '新規作成に成功する場合' do
      before do
        @group_params = {name: group.name}
        # beforeでsubjectを呼び出すとexpect前にグループが生成され、グループの数が+1されるのテストが成功しないため記述しない
      end

      it 'ステータス200を返す' do
        subject
        expect(response.status).to eq(200)
      end

      it 'グループの数が+1される' do
        expect {subject}.to change(Group, :count).by(1)
      end
    end

    context '新規作成に失敗する場合' do
      context 'グループ名が空で入力された場合' do
        before do
          @group_params = {name: ''}
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end

        it 'グループの数が±0を返す' do
          expect {subject}.to change(Group, :count).by(0)
        end

        it 'エラーメッセージを返す' do
          expect(@json["errors"]).to include("グループ名を入力してください")
        end
      end

      context 'グループ名が21文字以上で入力された場合' do
        before do
          @group_params = {name: 'a' * 21}
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end

        it 'グループの数が±0を返す' do
          expect {subject}.to change(Group, :count).by(0)
        end

        it 'エラーメッセージを返す' do
          expect(@json["errors"]).to include("グループ名は20文字以内で入力してください")
        end
      end

      context 'グループ名が既に存在している場合' do
        before do
          another_group = create(:group)
          @group_params = {name: another_group.name}
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end

        it 'グループの数が±0を返す' do
          expect {subject}.to change(Group, :count).by(0)
        end

        it 'エラーメッセージを返す' do
          expect(@json["errors"]).to include("グループ名はすでに存在します")
        end
      end
    end
  end

  describe 'グループ更新機能(api/v1/groups#update)' do
    let(:group) { create(:group) }

    before do
      @api_v1_group_path_json = api_v1_group_path(group.id) + '.json' # api/v1/groups#update用のURLを生成
    end

    subject {patch @api_v1_group_path_json, params: { group: @group_params }} # api/v1/groups#updateへリクエストを送る

    context 'グループ更新に成功する場合' do
      before do
        @group_params = {name: (group.name + 'test')}
        subject
        @json = JSON.parse(response.body)
      end

      it 'ステータス200を返す' do
        expect(response.status).to eq(200)
      end

      it 'リクエストで送られたグループ名を返す' do
        expect(@json["name"]).to eq(@group_params[:name])
      end
    end

    context 'グループ更新に失敗する場合' do
      context 'グループ名が空で入力された場合' do
        before do
          @group_params = {name: ''}
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end
  
        it 'エラーメッセージを返す' do
          expect(@json["errors"]).to include("グループ名を入力してください")
        end
      end

      context 'グループ名が21文字以上で入力された場合' do
        before do
          @group_params = {name: 'a' * 21}
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end
  
        it 'エラーメッセージを返す' do
          expect(@json["errors"]).to include("グループ名は20文字以内で入力してください")
        end
      end

      context 'グループ名が既に存在していた場合' do
        before do
          another_group = create(:group)
          @group_params = {name: another_group.name}
          subject
          @json = JSON.parse(response.body)
        end

        it 'ステータス200を返す' do
          expect(response.status).to eq(200)
        end
  
        it 'エラーメッセージを返す' do
          expect(@json["errors"]).to include("グループ名はすでに存在します")
        end
      end
    end
  end

  describe 'グループ削除機能(api/v1/groups#destroy)' do
    let(:group) { create(:group) }

    before do
      @api_v1_group_path_json = api_v1_group_path(group.id) + '.json' # api/v1/groups#destroy用のURLを生成
    end

    subject {delete @api_v1_group_path_json} # api/v1/groups#destroyへリクエストを送る

    context '削除に成功する場合' do
      it 'ステータス200を返す' do
        subject
        expect(response.status).to eq(200)
      end

      it 'グループの数が-1を返す' do
        expect {subject}.to change(Group, :count).by(-1)
      end
    end

    context '削除に失敗する場合' do
      context '存在しないグループを削除した場合' do
        before do
          subject # グループ初回削除
        end

        it 'ステータス200を返す' do
          subject
          expect(response.status).to eq(200)
        end

        it 'グループの数が±0を返す' do
          expect {subject}.to change(Group, :count).by(0)
        end
      end
    end
  end
end
