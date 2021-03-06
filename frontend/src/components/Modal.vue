<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay">
      <div class="modal-window">
        <div class="modal-content" v-if="notice !== null">
          <div class="title">通知</div>
          <div class="content">
            <ul v-if="notice.success !== undefined">
              <li class="success-txt" v-for="message in notice.success">{{message}}</li>
            </ul>
            <ul v-else-if="notice.errors !== undefined">
              <li class="error-txt" v-for="message in notice.errors">{{message}}</li>
            </ul>
          </div>
        </div>
        <div class="modal-content" v-else-if="modalOption === 'create'">
          <div class="title">グループ新規作成</div>
          <form class="content" @submit.prevent="createRequestGroup">
            <input class="input-text" type="text" v-model="newGroup.name" placeholder="グループ名">
            <input class="input-submit" type="submit" value="登録">
          </form>
        </div>
        <div class="modal-content" v-else-if="modalOption === 'update'">
          <div class="title">グループ編集</div>
          <form class="content" @submit.prevent="updateRequestGroup(editGroup.index)">
            <input class="input-text" type="text" v-model="editGroup.name" placeholder="グループ名">
            <input class="input-submit" type="submit" value="更新">
          </form>
        </div>
        <div class="modal-content" v-else-if="modalOption === 'delete'">
          <div class="title">グループ削除</div>
          <form class="content" @submit.prevent="destroyRequestGroup(deleteGroup.index)">
            <p class="input-text text-center">グループ名: {{deleteGroup.name}}</p>
            <input class="input-submit" type="submit" value="本当に削除しますか？">
          </form>
        </div>
        <footer class="modal-footer">
          <slot name="footer">
            <button @click="$emit('close')" class="close-btn">Close</button>
          </slot>
        </footer>
      </div>
    </div>
  </transition>
</template>

<script>
import axios from 'axios';

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  props: [
    'groups',
    'modalOption',
    'editGroup',
    'deleteGroup',
    'notice'
  ],
  data: function () {
    return {
      newGroup: {
        name: ''
      }
    }
  },
  created() {
  },
  methods: {
    createRequestGroup: function(e){
      const _this = this;
      if (_this.newGroup.name !== ''){
        const group_params = {name: _this.newGroup.name};
        axios.post(_this.$API_V1_GROUPS_PATH_JSON, group_params)
        .then(function(response){
          if (!response.data.errors){
            const newGroupData = {
              id: response.data.id,
              name: response.data.name,
              unread_count: 0,
              messages: []
            };
            _this.notice = {success: ['グループ作成が成功しました']};
            _this.$emit('addNewGroup', newGroupData);
          } else {
            _this.notice = {errors: response.data.errors};
          }
        })
        .catch(function(error){
          alert(error.message);
        });
      } else {
        _this.notice = {errors: ['グループ名を入力してください']};
      }
    },
    updateRequestGroup: function(index){
      const _this = this;
      const group_id = _this.editGroup.id;
      const API_V1_GROUP_PATH_JSON = `/api/v1/groups/${group_id}.json`;
      if (_this.editGroup.name !== ''){
        const group_params = {name: _this.editGroup.name};
        axios.patch(API_V1_GROUP_PATH_JSON, group_params)
        .then(function(response){
          if (!response.data.errors){
            _this.groups[index].name = response.data.name;
            _this.notice = {success: ['グループ更新が成功しました']};
          } else {
            _this.notice = {errors: response.data.errors};
          }
        })
        .catch(function(error){
          alert(error.message);
        });
      } else {
        _this.notice = {errors: ['グループ名を入力してください']};
      }
    },
    destroyRequestGroup: function(index){
      const _this = this;
      const group_id = _this.deleteGroup.id;
      const API_V1_GROUP_PATH_JSON = `/api/v1/groups/${group_id}.json`;
      axios.delete(API_V1_GROUP_PATH_JSON)
      .then(function(response){
        if (!response.data.errors){
          _this.notice = {success: ['グループ削除が成功しました']};
          _this.$emit('deleteGroupFromGroups', index);
        } else {
          _this.notice = {errors: response.data.errors};
        }
      })
      .catch(function(error){
        alert(error.message);
      });
    }
  },
}
</script>

<style lang="scss" scoped>
.modal {
  &.modal-overlay {
    display: flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    z-index: 30;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
  }
  &-window {
    width: 50%;
    height: 50%;
    background: #fff;
    border-radius: 4px;
    overflow: hidden;
  }
  &-content {
    height: calc(100% - 50px);
    padding: 10px 20px;
    .title {
      text-align: center;
    }
    .content {
      height: calc(100% - 25px);
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      .success-txt {
        color: #0F0;
        font-weight: bold;
      }
      .error-txt {
        color: #F00;
        font-weight: bold;
      }
      .input-text {
        width: 50%;
        height: 30px;
        margin: 30px 0;
        padding: 0;
      }
      .input-submit {
        width: 50%;
      }
      .text-center {
        text-align: center;
      }
    }
  }
  &-footer {
    height: 50px;
    background: #ccc;
    padding: 10px;
    text-align: center;
    .close-btn {
      padding: 5px;
    }
  }
}
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.4s;
  .modal-window {
    transition: opacity 0.4s, transform 0.4s;
  }
}
.modal-leave-active {
  transition: opacity 0.6s ease 0.4s;
}
.modal-enter, .modal-leave-to {
  opacity: 0;
  .modal-window {
    opacity: 0;
    transform: translateY(-20px);
  }
}
</style>
