
contract EtherStore {

    bool reEntrancyMutex = false;
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {

        require(!reEntrancyMutex);

        require(balances[msg.sender] >= _weiToWithdraw);

        require(_weiToWithdraw <= withdrawalLimit);

        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        balances[msg.sender] -= _weiToWithdraw;

        lastWithdrawTime[msg.sender] = now;

        reEntrancyMutex = true;

        msg.sender.transfer(_weiToWithdraw);

        reEntrancyMutex = false;
    }

}
