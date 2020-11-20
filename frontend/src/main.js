import Vue from 'vue';
import App from './App.vue';
import ActionCable from 'actioncable';

const cable = ActionCable.createConsumer('ws:localhost:3000/cable');
Vue.prototype.$cable = cable;

Vue.prototype.$API_V1_GROUPS_PATH_JSON = '/api/v1/groups.json';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App)
  }).$mount();
  document.body.appendChild(app.$el);
});
