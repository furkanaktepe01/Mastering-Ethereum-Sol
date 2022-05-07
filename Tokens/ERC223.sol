
interface ERC223 {

    uint public totalSupply;
    function balanceOf(address owner) public view returns (uint);

    function name() public view returns (string _name); 
    function symbol() public view returns (string _symbol);
    function decimals() public view returns (uint8 _decimals);
    function totalSupply() public view returns (uint256 _supply);

    function transfer(address to, uint value) public returns (bool ok);
    function transfer(address to, uint value, bytes data) public returns (bool ok);
    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);

    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data); 

}

/*
    ERC223 implementations detects whether the destination address is contract or not:

    function isContract(address _addr) private view returns (bool is_contract) {
        uint length;
        assembly { length := extcodesize(_addr) }
        return (length > 0);
    }

    ERC223 requires that contracts designed to accept tokens implements a function named tokenFallback,
    if destination of transfer is a contract without a tokenFallback implementation, transfer fails.

*/
