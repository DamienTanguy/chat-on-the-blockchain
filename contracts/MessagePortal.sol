// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract MessagePortal {
	
	uint256 totalMessages; //number of total messages

	struct Message {
		string text;
		address from;
		uint256 datetime;
	}

	Message[] allMessages; //store all messages

	mapping(address => uint256) messagesPerUser; //counter of messages per user

	//event that is sent to the front end
	// Events are used for return values from the transaction and as a cheap data storage.
	event NewMessage(address indexed from, uint256 timestamp, string message);
	//indexed --> logsEvents can be filtered by name and by contract address.
	//The indexed parameters for logged events will allow you to search for these events using the indexed parameters as filters.

	constructor(){ console.log('constructor called'); }

	function sendMessage(string memory _newMessage) public {
		console.log("%s has sent a message", msg.sender);

		allMessages.push(Message(_newMessage, msg.sender, block.timestamp));

		totalMessages +=1;
		messagesPerUser[msg.sender] +=1;

		console.log("Number of messages of %a %s >> ", msg.sender, messagesPerUser[msg.sender]);

		//emit event for web app
		emit NewMessage(msg.sender, block.timestamp, _newMessage);

		console.log("AllMessages updated");
	}

	function getAllMessages() public view returns(Message[] memory){
		return allMessages;
	}

	function getTotalMessages() public view returns(uint256){
		return totalMessages;
	}

}