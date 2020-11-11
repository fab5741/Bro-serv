<template>
  <span>{{time}}</span>
</template>

<script>
export default {
  data() {
    return {
      time: '',
      myInterval: 0,
    };
  },
  methods: {
    updateTime: function update() {
      const time = new Date();
      let minutes = time.getMinutes();
      minutes = minutes > 9 ? minutes : `0${minutes}`;
      let heure = time.getHours();
      heure = heure > 9 ? heure : `0${heure}`;
      const datestring = `${heure}:${minutes}`;
      this.time = datestring;
    },
  },
  created: function created() {
    this.updateTime();
    this.myInterval = setInterval(this.updateTime, 1000);
  },
  beforeDestroy: function before() {
    clearInterval(this.myInterval);
  },
};
</script>

<style scoped>
</style>
