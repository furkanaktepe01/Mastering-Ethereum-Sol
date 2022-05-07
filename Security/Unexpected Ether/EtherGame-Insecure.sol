
contract EtherGame {

    uint public payoutMileStone1 = 3 ether;
    uint public mileStone1Reward = 2 ether;
    uint public payoutMileStone2 = 5 ether;
    uint public mileStone2Reward = 3 ether;
    uint public finalMileStone = 10 ether;
    uint public finalReward = 5 ether;

    mapping(address => uint) redeemableEther;

    function play() public payable {

        require(msg.value == 0.5 ether);

        uint currentBalance = this.balance + msg.value;

        require(currentBalance <= finalMileStone);

        if(currentBalance == payoutMileStone1) {
            redeemableEther[msg.sender] += mileStone1Reward;
        }

        else if(currentBalance == payoutMileStone2) {
            redeemableEther[msg.sender] += mileStone2Reward;
        }
    
        else if(currentBalance == finalMileStone) {
            redeemableEther[msg.sender] += finalReward;
        }

        return;
    }

    function claimReward() public {

        require(this.balance == finalMileStone);

        require(redeemableEther[msg.sender] > 0);

        uint transferValue = redeemableEther[msg.sender];

        redeemableEther[msg.sender] = 0;

        msg.sender.transfer(transferValue);
    }

}
