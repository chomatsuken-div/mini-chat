<template>
  <div class="chat-conteiner">
    <modal v-if="isShowModal" v-bind:notice="notice" @close="closeModal"></modal>
    <div class="chat-conteiner__content" v-if="groupIndex !== null">
      <div class="chat-conteiner__content__group-box">
        <div class="chat-conteiner__content__group-box__left">
          <div class="chat-conteiner__content__group-box__left__name">{{groups[groupIndex].name}}</div>
          <button class="chat-conteiner__content__group-box__left__edit" @click="editGroup(groupIndex)">編集</button>
        </div>
        <button class="chat-conteiner__content__group-box__right" @click="deleteGroup(groupIndex)">チャットグループを削除する</button>
      </div>
      <ul class="chat-conteiner__content__messages">
        <li v-for="message in groups[groupIndex].messages">
          {{message}}
        </li>
      </ul>
      <form class="chat-conteiner__content__form" @submit.prevent="createRequestMessage(groupIndex)">
        <input type="text" class="chat-conteiner__content__form__text" v-model="newMessage.content">
        <input type="submit" class="chat-conteiner__content__form__submit" value="送信">
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Modal from './Modal.vue';

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  components:{
    Modal
  },
  props: [
   'groups',
   'groupIndex'
  ],
  data: function () {
    return {
      isShowModal: false,
      notice: '',
      newMessage: {
        content: '',
        groupIndex: ''
      }
    }
  },
  methods: {
    openModal() {
      this.isShowModal = true;
    },
    closeModal() {
      this.isShowModal = false;
    },
    editGroup: function(index){
      this.$emit('updateGroup', index);
    },
    deleteGroup: function(index){
      this.$emit('selectedDeleteGroup', index);
    },
    createRequestMessage: function(groupIndex){
      const _this = this;
      const group = _this.groups[groupIndex];
      const API_V1_GROUP_MESSAGES_PATH_JSON = `/api/v1/groups/${group.id}/messages.json`;
      if (_this.newMessage.content !== ''){
        const message_params = {content: _this.newMessage.content};
        axios.post(API_V1_GROUP_MESSAGES_PATH_JSON, message_params)
        .then(function(response){
          if (!response.data.errors){
            _this.newMessage.groupIndex = groupIndex;
            _this.$emit('addNewMessage', _this.newMessage);
          } else {
            _this.openModal();
            _this.notice = {errors: response.data.errors};
          }
        })
        .catch(function(error){
          alert(error.message);
        });
      } else {
        _this.openModal();
        _this.notice = {errors: ['メッセージを入力してください']};
      }
    }
  },
}
</script>

<style lang="scss" scoped>
.chat-conteiner {
  width: calc(100% - 300px);
  height: 100vh;
  padding: 30px;
  &__content {
    height: 100%;
    &__group-box {
      display: flex;
      justify-content: space-between;
      border-bottom: #808080 1px solid;
      padding-bottom: 10px;
      button {
        border: none;
      }
      &__left {
        display: flex;
        &__name {
          font-size: 1.4rem;
        }
        &__edit {
          margin-left: 20px;
          color: #C0C0C0;
        }
      }
      &__right {
        font-size: 1rem;
        color: #C0C0C0;
      }
    }
    &__messages {
      height: calc(100% - 146px);
      margin: 30px;
      overflow: auto;
      &::-webkit-scrollbar {
        display:none;
      }
      li {
        padding-bottom: 20px;
      }
    }
    &__form {
      display: flex;
      &__text {
        width: 100%;
        border: #808080 1px solid;
        border-radius: 3px;
      }
      &__submit {
        background: #808080;
        margin-left: 20px;
        padding: 10px;
        border: none;
        border-radius: 3px;
        color: #fff;
      }
    }
  }
}
</style>
