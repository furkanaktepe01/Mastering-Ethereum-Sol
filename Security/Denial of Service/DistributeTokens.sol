
contract DistributeTokens {

    address public owner;
    address[] investors;
    uint[] investorTokens;

    // ...

    function invest() public payable {
        investors..push(msg.sender);
        investorTokens.push(msg.value * 5);
    }

    function distribute() public {

        require(msg.sender == owner);

        // gas required to execute the loop 
        // over the artificially infilated array
        // can exceed the block gas limit
        for (uint i = 0; i < investors.length; i++) {
            transferToken(investors[i], investorTokens[i]);
        }

    }

    // Withdrawal Pattern: everyone withdraws individually via the withdraw()

}
