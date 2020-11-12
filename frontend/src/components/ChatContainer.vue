<template>
  <div class="chat-conteiner">
    <div class="chat-conteiner__content" v-for="(group, index) in groups" :key="index" v-if="group.curernt_group == true">
      <div class="chat-conteiner__content__group-box">
        <div class="chat-conteiner__content__group-box__left">
          <div class="chat-conteiner__content__group-box__left__name">{{group.name}}</div>
          <button class="chat-conteiner__content__group-box__left__edit">編集</button>
        </div>
        <button class="chat-conteiner__content__group-box__right">チャットグループを削除する</button>
      </div>
      <ul class="chat-conteiner__content__messages">
        <li v-for="message in group.messages">
          {{message.text}}
        </li>
      </ul>
      <form class="chat-conteiner__content__form">
        <input type="text" class="chat-conteiner__content__form__text">
        <input type="submit" class="chat-conteiner__content__form__submit" value="送信">
      </form>
    </div>
  </div>
</template>

<script>

export default {
  props: [
   'groups'
  ],
  data: function () {
    return {
    }
  }
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