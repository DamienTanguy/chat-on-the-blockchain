<template>
  <div>
    <button v-if="walletAddress == null " @click="requestAccount">Connect your wallet</button>
    <p>Wallet Address: {{ walletAddress }}</p>
    <p>Number of Messages: {{ totalMessages }} </p>
    <p>All Messages:</p>
    <ul>
      <li v-for="msg in allMessages" :key="msg">
        <div>
          <p></p>
          <span> {{ msg.from.slice(0,2) }} ... {{ msg.from.slice(-4) }}</span>
          said:
          <blockquote>{{ msg.text }}</blockquote>
          posted on {{ msg.datetime }}
        </div>
      </li>
    </ul>
    <textarea v-model="message" :disabled="walletAddress == null "></textarea>
    <button @click="sendMessage" :disabled="walletAddress == null || trxInProgress"> {{ trxInProgress ? `Sending...` : `Send message`}} </button>

  </div>
</template>

<script>
  import { ethers } from 'ethers';
  import MessagePortal from '@/artifacts/contracts/MessagePortal.sol/MessagePortal.json'; //import of the ABI to interact with the smart contract

  export default {
    name: 'MessagePortal',
    data() {
      return {
        contractAddress: '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0', //address of the contract deployement with npx hardhat run scripts/deploy.js ...
        walletAddress: null,
        message: '',
        allMessages: [],
        totalMessages: 0,
        trxInProgress: false
      }
    },
    mounted(){
      //this.requestAccount();
      if(this.walletAddress !== null){
        //console.log('Wallet connected');
        this.retrieveMessages();
        this.retrieveTotalMessages();
      }
    },
    methods : {
      requestAccount : async function(){ //the user has to connect to our webiste with Metamask
        //console.log('requestAccount');
        const data = await window.ethereum.request({method: 'eth_requestAccounts'});
        this.walletAddress = data[0];
        this.retrieveMessages();
        this.retrieveTotalMessages();
        //console.log(this.walletAddress);
      },
      retrieveMessages : async function(){ //to get the message stored in the blockchain
        this.allMessages = [];
        if(typeof window.ethereum !== 'undefined') { //Metamask needs to be connected
          const provider = new ethers.providers.Web3Provider(window.ethereum);
          const contract = new ethers.Contract(this.contractAddress, MessagePortal.abi, provider); //new instance of the contract to interact with the function of the contract
          try {
            const data = await contract.getAllMessages(); //function of the contract
            console.log('data');
            console.log(data);
            data.forEach(message => this.allMessages.push({
                from: message.from,
                text: message.text,
                datetime: new Date(message.datetime * 1000)
              })
            )
          } catch(err) {
            console.log(err);
          }
        }
      },
      retrieveTotalMessages: async function(){
        if(typeof window.ethereum !== 'undefined'){
          const provider = new ethers.providers.Web3Provider(window.ethereum);
          const contract = new ethers.Contract(this.contractAddress, MessagePortal.abi, provider);
          try {
            const data = await contract.getTotalMessages();
            this.totalMessages = data;
          } catch(err) {
            console.log(err);
          }
        }
      },
      sendMessage: async function(){ //to modify the message stored in the blockchain
        if(typeof window.ethereum !== "undefined"){
          this.trxInProgress = true;
          await this.requestAccount();
          const provider = new ethers.providers.Web3Provider(window.ethereum);
          const signer = provider.getSigner(); // need a signer to sign the transaction
          const contract = new ethers.Contract(this.contractAddress, MessagePortal.abi, signer);
          try {
            const transaction = await contract.sendMessage(this.message, {gasLimit: 300000}); //function of the contract

            await transaction.wait();
            this.message = '';
            this.trxInProgress = false;

            this.retrieveMessages();

          } catch(err) {
            console.log(err);
            this.trxInProgress = false;
          }

        }
      }

    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
