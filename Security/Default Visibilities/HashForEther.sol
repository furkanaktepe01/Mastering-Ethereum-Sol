
contract HashForEther {

    function withdrawWinnings() {
        
        require(uint32(msg.sender) == 0);

        _sendWinnings(msg.sender);
    }

    // supposed to be private
    function _sendWinnings(address winner) {
        winner.transfer(this.balance);
    }

}
