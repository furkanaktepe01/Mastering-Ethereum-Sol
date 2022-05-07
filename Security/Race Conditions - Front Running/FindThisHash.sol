
contract FindThisHash {

    bytes32 constant public hash = 
        0xb5b5b97fafd9855eec9b41f74dfb6c38f5951141f9a3ecd7f44d5479b630ee0a;

    constructor() public payable { }

    // Attacker, watching transaction pool, sees the solution transaction
    // recreates it with a higher gasPrice, which gets mined before the original,
    // then receives the reward.

    function solve(string solution) public {

        require(hash == sha3(solution));

        msg.sender.transfer(1000 ether);
    }

    // Setting an upper bound for the gasPrice

    // Commit-Reveal Scheme: user sends a transaction with hidden data,
    // which gets included in a block, then sends another transaction to reveal the data

}
