pragma solidity ^0.6.4;

contract Owned {

    address payable owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

}

contract Mortal is Owned {

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

}

contract Faucet is Mortal {

    uint256 public withdrawalLimit = 0.1 ether; 

    event Deposit(address indexed from, uint amount);
    event Withdrawal(address indexed to, uint amount);

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint withdraw_amount) public {

        require(withdraw_amount <= withdrawalLimit);

        require(address(this).balance >= withdraw_amount);

        msg.sender.transfer(withdraw_amount);

        emit Withdrawal(msg.sender, withdraw_amount);
    }

}

contract Token is Mortal {

    Faucet _faucet;

    constructor(address _f) {
        _faucet = Faucet(_f);
        _faucet.withdraw(0.1 ether);
    }

}
