
library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint c = a / b;
        return c;    
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }

}

contract TimeLock {

    using SafeMath for uint;

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() public payable {
        
        balances[msg.sender] = balances[msg.sender].add(msg.value); 
        
        lockTime[msg.sender] = now.add(1 weeks);
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }

    function withdraw() public {

        require(balances[msg.sender] > 0);

        require(now > lockTime[msg.sender]);
    
        uint balance = balances[msg.sender];

        balances[msg.sender] = 0;

        msg.sender.transfer(balance);
    }
    
}
