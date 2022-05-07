
contract Token {
    
    mapping(address => uint) balances;
    uint public totalSupply;

    constructor(uint _initialSupply) {
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply;
    }

    function transfer(address _to, uint _value) public returns (bool) {

        require(balances[msg.sender] - _value >= 0);

        balances[msg.sender] -= _value;

        balances[_to] += _value;

        return true; 
    }

    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }

}
