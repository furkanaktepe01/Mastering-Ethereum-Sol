
contract ICO {

    bool public isFinalized;
    address public owner;

    // if owner cannot call finalize()
    // no tokens can be transferred
    function finalize() public {
        require(msg.sender == owner);
        isFinalized = true;
    }

    // ...

    function transferFunds(address _to, uint _value) returns (bool) {
        require(isFinalized);
        transfer(_to, _value);
    }

    // Owner be a multisig contract

    // Time-Lock:
    // require(msg.sender == owner || now > unlockTime);

}
