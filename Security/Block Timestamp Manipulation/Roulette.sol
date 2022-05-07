
contract Roulette {

    uint public pastBlockTime;

    constructor() public payable { }

    // Miner adjusts the block timestamp
    // also mines his one before any other, since one bet per block is allowed
    // in order to win 
    function () public payable {

        require(msg.value == 10 ether);

        require(now != pastBlockTime);

        pastBlockTime = now;

        if (now % 15 == 0) {
            msg.sender.transfer(this.balance);
        }
    }

    // Block Timestamps should not be the source of entropy

    // Block Number can be used for time-sensitive logic
    // e.g. unlocking contracts, completing an ICO, enforcing expiry dates

} 
