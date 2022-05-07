
contract UsersContract {

    function () public payable {
        revert();
    }

}

contract ExternalDependent {

    address public usersContract;
    string public stage = "Stage_0";    

    // ...

    // UsersContract will never accept the ether sent
    // External Dependent will never proceed to the next stage
    function withdraw() {

        require(msg.sender == usersContract);
        
        usersContract.transfer(this.balance);
    
        stage = "Stage_1";
    }

    // Time-Lock:
    // require(msg.sender == usersContract || now > unlockTime);

}
