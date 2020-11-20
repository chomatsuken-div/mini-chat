<template>
  <div id="main">
    <modal v-if="isShowModal" v-bind:groups="groups" v-bind:modalOption="modalOption" v-bind:notice="notice" v-bind:editGroup="editGroup" v-bind:deleteGroup="deleteGroup" @close="closeModal" @addNewGroup="addGroups" @deleteGroupFromGroups="deleteGroupFromGroups"></modal>
    <sidebar v-bind:groups="groups" @createGroup="createGroup" @changeGroup="currentGroupChange"></sidebar>
    <chat-container v-bind:groups="groups" v-bind:groupIndex="currentGroupIndex" @updateGroup="updateGroup" @selectedDeleteGroup="selectedDeleteGroup" @addNewMessage="addNewMessage"></chat-container>
  </div>
</template>

<script>
import Modal from './components/Modal.vue';
import Sidebar from './components/Sidebar.vue';
import ChatContainer from './components/ChatContainer.vue';

import axios from 'axios';

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

  export default {
    components:{
      Modal,
      Sidebar,
      ChatContainer
    },
    data: function () {
      return {
        isShowModal: false,
        modalOption: '',
        notice: null,
        currentGroupIndex: null,
        editGroup : null,
        deleteGroup: null,
        groups: []
      }
    },
    methods: {
      openModal() {
        this.isShowModal = true;
      },
      closeModal() {
        this.isShowModal = false;
      },
      currentGroupChange: function (index) {
        const group = this.groups[index];
        group.unread_count = 0;
        this.currentGroupIndex = index;
      },
      createGroup: function(e){
        this.openModal();
        this.modalOption = 'create';
      },
      addGroups: function(group){
        this.groups.unshift(group);
        this.currentGroupIndex = 0;
      },
      updateGroup: function(index){
        const group = this.groups[index];
        this.editGroup = {
          id: group.id,
          name: group.name,
          index: index
        };
        this.openModal();
        this.modalOption = 'update';
      },
      selectedDeleteGroup: function(index){
        const group = this.groups[index];
        this.deleteGroup = {
          id: group.id,
          name: group.name,
          index: index
        };
        this.openModal();
        this.modalOption = 'delete';
      },
      deleteGroupFromGroups: function(index){
        this.groups.splice(index, 1);
        this.currentGroupIndex = null;
      },
      addNewMessage: function(newMessage){
        this.groups[newMessage.groupIndex].messages.unshift(newMessage);
      }
    },
    created() {
      const _this = this;
      axios.get(_this.$API_V1_GROUPS_PATH_JSON)
      .then(function(response){
        if (!response.data.errors){
          const groups_array = [];
          response_data.forEach(function(group){
            const molding_group = {
              id: group.id,
              name: group.name,
              unread_count: 0,
              messages: group.messages
            };
            groups_array.push(molding_group);
          })
          _this.$data.groups = groups_array;
        }
      })
      .catch(function(error){
        alert(error.message);
      });
    }
  }
</script>

<style lang="scss">
// reset //

html, body, div, span, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
abbr, address, cite, code,
del, dfn, em, img, ins, kbd, q, samp,
small, strong, sub, sup, var,
b, i,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, figcaption, figure,
footer, header, hgroup, menu, nav, section, summary,
time, mark, audio, video {
 margin:0;
 padding:0;
 border:0;
 outline:0;
 vertical-align:baseline;
 background:transparent;
 box-sizing: border-box;
}

body {
 min-width: 1000px;
 color: #000;
 line-height: 1.6;
 font-weight: 400;
 font-family: 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', 'YuGothic', '游ゴシック', 'メイリオ', Meiryo, -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Arial, sans-serif;

 width: 100%;
 font-smoothing: antialiased;
 font-variant-numeric: tabular-nums;
 -webkit-font-smoothing: antialiased;
}

article,aside,details,figcaption,figure,
footer,header,hgroup,menu,nav,section {
 display:block;
}

ul, ol {
 list-style:none;
}

a {
 margin:0;
 padding:0;
 vertical-align:baseline;
 text-decoration: none;
 color: inherit;
}

table {
 border-collapse:collapse;
 border-spacing:0;
}

hr {
 display:block;
 height:1px;
 border:0;
 border-top:1px solid #cccccc;
 margin:1em 0;
 padding:0;
}

input, select {
 vertical-align:middle;
}

img {
 vertical-align: bottom;
 line-height: 1.0;
}

button {
 line-height: 1.0;
 background-color: transparent;
 cursor: pointer;
 outline: none;
 padding: 0;
 appearance: none;
}
//////////

#main {
  display: flex;
}
</style>
