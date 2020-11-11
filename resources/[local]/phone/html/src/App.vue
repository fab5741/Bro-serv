<template>
  <div style="height: 100vh; width: 100vw;">
  <div v-if="show === true && tempoHide === false" :style="{zoom: zoom}">
    <div class="phone_wrapper">
      <div id="app" class="phone_screen">
        <transition>
          <keep-alive>
            <router-view></router-view>
          </keep-alive>
        </transition>
      </div>
   </div>
  </div>
</div>

</template>

<script>
import { mapGetters, mapActions } from 'vuex';
// import { Howl } from 'howler';

export default {
  name: 'app',
  components: {
  },
  data: function data() {
    return {
      soundCall: null,
    };
  },
  methods: {
    ...mapActions(['loadConfig', 'rejectCall']),
    closePhone() {
      this.$phoneAPI.closePhone();
    },
  },
  computed: {
    ...mapGetters(['show', 'zoom', 'coque', 'sonido', 'appelsInfo', 'myPhoneNumber', 'volume', 'tempoHide']),
  },
};
</script>

<style lang="scss">
body {
  font-size: 20px;
  margin: 0;
  @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap');
  font-family: 'Roboto', sans-serif;
  padding: 0;
}

.phone_infoBare {
  height: 24px;
}

.phone_app{
  height: 100%;
  width: 100%;
  display: flex;
  flex-direction: column;
}

.phone_title {
  padding-left: 24px;
  padding-top: 6px;
  height: 64px;
  line-height: 52px;
  font-size: 24px;
  font-weight: 500;
  padding-left: 64px;
}
.phone_title .btn-back {
  width: 42px;
  height: 42px;
  color: rgba(255,255,255, 0.7);
  line-height: 42px;
  border-radius: 50%;
  background-color: transparent;
  border: none;
  margin: 0;
  padding: 0;
  position: absolute;
  left: 16px;
  top: 35px;
  outline: none;
  text-shadow: none;
  text-align: center;
}
.phone_title .btn-back:hover {
  background-color: rgba(255,255,255, 0.3);
  color: white;
}

.phone_content {
  height: 100%;
  overflow-y: auto;
}

.phone_wrapper {
  width: 300px;
  height: 575px;
  background-size: cover;
  background: url(./assets/img/s10.png);
  background-size: 100%;
  background-repeat: no-repeat;
  position: absolute;
  right: 0;
  bottom: 0px;
}

.phone_screen{
  overflow: hidden;
  position: absolute;
  background-color: white;
  bottom: 100px;
  left: 30px;
  right: 50px;
  top: 60px;
  display: flex;
  width: 241px;
  height: 480px;
  z-index: -1;
}

* {
  font-family: 'Roboto', sans-serif;
  box-sizing: border-box;
}
*::-webkit-scrollbar-track
{
    box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
    background-color: #F5F5F5;
}
*::-webkit-scrollbar
{
    width: 3px;
    background-color: transparent;
}
*::-webkit-scrollbar-thumb
{
    background-color: #666;
}
</style>
