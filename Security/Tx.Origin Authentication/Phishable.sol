
contract Phishable {

    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function () public payable { }

    function withdrawAllAndTransferTo(address _recipient) public {

        require(tx.origin == owner);

        _recipient.transfer(this.balance);
    }

    // tx.origin should not be used for authentication or authorization

}
