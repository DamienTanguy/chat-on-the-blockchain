<template>
  <MessagePortal />
</template>

<script>
// Based on https://soliditytips.com/articles/web3-simple-app-vuejs-hardhat
import MessagePortal from './components/MessagePortal.vue'

export default {
  name: 'App',
  components: {
    MessagePortal
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
