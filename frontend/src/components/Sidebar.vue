<template>
  <div class="sidebar">
    <div class="sidebar__add-group">
      <button @click="$emit('createGroup')"></button>
    </div>
    <ul class="sidebar__groups">
      <li class="sidebar__groups__list" v-for="(group, index) in groups" :key="index">
        <button @click="selectGroup(index)">{{group.name}}</button>
        <div class="circle-red" v-if="group.unread_count > 0">{{group.unread_count}}</div>
      </li>
    </ul>
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
  },
  methods: {
    selectGroup: function(index){
      this.$emit('changeGroup', index);
    }
  }
}
</script>

<style lang="scss" scoped>
.sidebar {
  width: 300px;
  height: 100vh;
  background: #808080;
  color: #fff;
  &__add-group {
    height: 60px;
    button {
      width: 35px;
      height: 35px;
      margin: 20px 0 0 20px;
      border: #fff solid 1px;
      border-radius: 999px;
    }
    button::before {
      content: "\02b";
      font-size: 1.6rem;
      color: #fff;
    }
  }
  &__groups {
    padding: 30px;
    &__list {
      height: 50px;
      display: flex;
      padding-bottom: 30px;
      button {
        font-size: 1rem;
        color: #fff;
        border: none;
      }
      .circle-red {
        height: 25px;
        width: 25px;
        margin-left: 20px;
        border-radius: 999px;
        text-align: center;
        background: #F00;
      }

    }
  }
}
</style>
