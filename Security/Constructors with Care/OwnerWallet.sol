
contract OwnerWallet {

    address public owner;

    // misspelled constructor:
    // anyone can call to become the owner
    // and then withdraw the funds 
    function ownerWallet(address _owner) public {
        owner = _owner;
    }

    function () payable { }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    // constructor keyword should be used to declare constructors

}
