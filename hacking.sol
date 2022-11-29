// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract EtherBalance {

    mapping(address => uint) public balances;

    function deposit() public payable {

        balances[msg.sender] += msg.value;

    }

      function withdraw() public payable {

        uint bal = balances[msg.sender];
        require(bal >= 0, "Insufficient money");

        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Failed to withdraw");
        balances[msg.sender] = 0;

    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}

contract Attack {
    EtherBalance etherBalance;

    constructor(EtherBalance _etherBalance) {
        etherBalance = EtherBalance(_etherBalance);
    }

    function attack() public payable {

        address payable addr = payable(address(etherBalance));
        selfdestruct(addr);
    }
}