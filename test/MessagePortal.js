const { expect, assert } = require("chai");

describe('MessagePortal', function () {

  let contract;
  let allMessages;

  before(async function(){
    const messagePortal = await ethers.getContractFactory("MessagePortal");
    contract = await messagePortal.deploy();
    const result = await contract.sendMessage('message 1 to send');
    const result2 = await contract.sendMessage('message 2 to send');
    allMessages = await contract.getAllMessages();
  });

  it('should deploy the contract', async function(){
    const messagePortal = await ethers.getContractFactory("MessagePortal");
    let err = null;
    try {
      const MessagePortalDeployement = await messagePortal.deploy();
    }
    catch(error){
      err = error;
    }
    assert.equal(err, null, 'The contract is not deployed');
  });

  it('should send a message', async function(){
    let err = null;
    try {
      const result = await contract.sendMessage('message 1 to send');
    }
    catch(error){
      err = error;
    }
    assert.equal(err, null, 'The message has been sent');
  });

  it('should get all messages', async function(){
    expect(allMessages[0].text).to.equal("message 1 to send");
    expect(allMessages[1].text).to.equal("message 2 to send");
  });

  it('should get the umber total of messages', async function(){
    expect(allMessages.length).to.equal(2);
  });

})