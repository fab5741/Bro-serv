import Vue from 'vue';
import Router from 'vue-router';

import Home from '@/components/Home.vue';
import Appels from '@/components/Appels/Appels.vue';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home,
    }, {
      path: '/appels',
      name: 'appels',
      component: Appels,
    },
    {
      path: '*',
      redirect: '/',
    },
  ],
});
