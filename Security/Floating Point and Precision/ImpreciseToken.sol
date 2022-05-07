
contract ImpreciseToken {

    uint constant public tokensPerEth = 10;
    uint constant public weiPerEth = 1e18;
    mapping(address => uint) public balances;

    function buyTokens() public payable {
        
        // (0.7*1e18)/1e18 * 10 == 0
        // (2.8*1e18)/1e18 * 10 == 20
        uint tokens = msg.value/weiPerEth*tokensPerEth;
        
        balances[msg.sender] += tokens;
    }

    // ...

    function sellTokens(uint tokens) public {

        require(balances[msg.sender] >= tokens);
    
        // 8/10 == 0
        // 29/10 == 2
        uint eth = tokens/tokensPerEth;

        balances[msg.sender] -= tokens;

        msg.sender.transfer(eth*weiPerEth);
    }

    // Using ratios or rates that allow large numerators in fraction, 
    // e.g. weiPerTokens: uint tokens = msg.value/weiPerTokens 

    // Greater precision by ordering operations,
    // e.g. uint tokens = msg.value*tokensPerEth/weiPerEth 

    // Converting values to higher precision, then performing operations, 
    // then converting back down to the required precision of the output

}
