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
          {{message.content}}
        </li>
      </ul>
      <div class="chat-conteiner__content__form">
        <textarea class="chat-conteiner__content__form__text" ref="textarea_message" v-model="newMessage.content" v-bind:style="{height:obj.height}" @input="textAreaHeightSet" v-on:keydown.enter="cmdAndEnter"></textarea>
        <button class="chat-conteiner__content__form__submit" @click="speak(groupIndex)">送信</button>
      </div>
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
      messageChannel: null,
      newMessage: {
        content: '',
        groupIndex: ''
      },
      obj: {
        height: '100%',
        lineNumber: 0
      }
    }
  },
  created() {
    this.messageChannel = this.$cable.subscriptions.create( "MessageChannel", {
      received: (resultMessage) => {
        if (resultMessage.success !== undefined){
          const group = this.groups[this.groupIndex];
          const message = resultMessage.success;
          if (message.group_id === group.id){
            group.messages.unshift(message);
          }
        } else {
          this.openModal();
          this.notice = message.errors;
        };
        this.newMessage.content = '';
      },
    })
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
    speak: function(groupIndex) {
      if (this.newMessage.content !== ''){
        this.messageChannel.perform('speak', { 
          content: this.newMessage.content,
          group_id: this.groups[groupIndex].id
        });
      } else {
        this.openModal();
        this.notice = {errors: ['メッセージを入力してください']};
      }
      this.obj.height = '100%';
      this.obj.lineNumber = 0;
    },
    textAreaHeightSet: function(e){
      const textarea = this.$refs.textarea_message;
      const textareaHeight = textarea.scrollHeight;
      const newLineNum = textarea.value.match(/\n/g);
      if (newLineNum !== null && newLineNum.length > (this.obj.lineNumber + 2) && (textareaHeight <= 300)) {
        this.obj.height = `${textareaHeight + 10}px`;
        this.obj.lineNumber = newLineNum.length;
      };
    },
    cmdAndEnter: function(e){
      if (e.metaKey){
        this.speak(this.groupIndex);
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
      height: calc(100% - 200px);
      margin: 30px;
      overflow: auto;
      &::-webkit-scrollbar {
        display:none;
      }
      li {
        width: 100%;
        padding-bottom: 20px;
        white-space: pre-line;
        word-break: break-word;
      }
    }
    &__form {
      height: 100px;
      position: relative;
      &__text {
        height: 100%;
        width: calc(100% - 130px);
        position: absolute;
        bottom: 0;
        border: #808080 1px solid;
        border-radius: 3px;
      }
      &__submit {
        width: 100px;
        position: absolute;
        top: calc(50% - 20px);
        right: 0;
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
