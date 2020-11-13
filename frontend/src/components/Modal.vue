<template>
  <transition name="modal" appear>
    <div class="modal modal-overlay">
      <div class="modal-window">
        <div class="modal-content" v-if="modalOption == 'create'">
          <div class="title">グループ新規作成</div>
          <form class="content">
            <input class="input-text" type="text" name="name" placeholder="グループ名">
            <input class="input-submit" type="submit" value="登録">
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

export default {
  props: [
   'groups',
   'modalOption'
  ],
  data: function () {
    return {
    }
  }
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
      .input-text {
        width: 50%;
        height: 30px;
        margin: 30px 0;
        padding: 0;
      }
      .input-submit {
        width: 50%;
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
