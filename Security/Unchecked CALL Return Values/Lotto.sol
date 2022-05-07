
contract Lotto {

    bool public payedOut = false;
    address public winner;
    address public leftOverReceiver;
    uint public winAmount;

    // ...

    
    function sendToWinner() public {

        require(!payedOut);

        winner.send(winAmount); // unchecked return value: payedOut be true, even if send() failed

        payedOut = true;
    } 

    function withdrawLeftOver() public {

        require(payedOut);

        leftOverReceiver.send(this.balance);
    }

    // transfer(): reverts

    // Withdrawal Pattern: everyone withdraws individually via the withdraw()
    
}
