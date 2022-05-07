
contract FibonacciBalance {

    address public fibonacciLibrary;
    uint public calculatedFibNumber;
    uint public start = 3;
    uint public withdrawalCounter;
    bytes4 constant fibSig = bytes4(sha3("setFibonacci(uint256)"));

    constructor(address _fibonacciLibrary) public payable {
        fibonacciLibrary = _fibonacciLibrary;
    }

    function withdraw() {
        
        withdrawalCounter += 1;

        require(fibonacciLibrary.delegatecall(fibSig, withdrawalCounter));

        msg.sender.transfer(calculatedFibNumber * 1 ether);
    }

    function () public {
        // call setStart(attackingAddress): modifies storageSlot[0]
        // in the context of FibonacciBalance: the fibonacciLibrary 
        require(fibonacciLibrary.delegatecall(msg.data));
    }

}
