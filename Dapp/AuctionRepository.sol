pragma solidity ^0.5.16;

import "./DeedRepository.sol";

contract AuctionRepository {

    Auction[] public auctions;

    mapping(uint => Bid[]) public auctionBids;

    mapping(address => uint[]) public public auctionOwner;

    struct Bid {
        address payable from;
        uint256 amount;
    }

    struct Auction {
        string name;
        uint256 blockDeadline;
        uint256 startPrice;
        string metadata;
        uint256 deedId;
        address deedRepositoryAddress;
        address payable owner;
        bool active;
        bool finalized;
    }

    modifier isOwner(uint _auctionId) {
        
        require(auctions[_auctionId].owner == msg.sender);
        
        _;
    }

    modifier contractIsDeedOwner(address _deedRepositoryAddress, uint256 _deedId) {
    
        address deedOwner = DeedRepository(_deedRepositoryAddress).ownerOf(_deedId);

        require(deedOwner == address(this));

        _;
    }

    function () external {
        revert();
    }

    function getCount() public view returns (uint) {
        return auctions.length;
    }

    function getBidsCount(uint _auctionId) public view returns (uint) {
        return auctionBids[_auctionId].length;
    }

    function getAuctionsOf(address _owner) public view returns (uint[] memory) {
        uint[] memory ownedAuctions = auctionOwner[_owner];
        return ownedAuctions;
    }

    function getCurrentBid(uint _auctionId) public view returns (uint256, address) {

        uint bidsLength = auctionBids[_auctionId].length;

        if (bidsLength > 0) {
            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];
            return (lastBid.amount, lastBid.from);
        }

        return (uint256(0), address(0x0));
    }

    function getAuctionsCountOf(address _owner) public view returns (uint) {
        return auctionOwner[_owner].length;
    }

    function getAuctionById(uint _auctionId) public view returns (
        string name,
        uint256 blockDeadline,
        uint256 startPrice,
        string metadata,
        uint256 deedId,
        address deedRepositoryAddress,
        address payable owner,
        bool active,
        bool finalized
    ) {

        Auction memory auc = auctions[_auctionId];

        return (
            auc.name,
            auc.blockDeadline,
            auc.startPrice,
            auc.metadata,
            auc.deedId,
            auc.deedRepositoryAddress,
            auc.owner,
            auc.active,
            auc.finalized
        );
    }

    function createAuction(address _deedRepositoryAddress, uint256 _deedId, string memory _auctionTitle, string memory _metadata, uint256 _startPrice, uint _blockDeadline) public contractIsDeedOwner(_deedRepositoryAddress, _deedId) returns (bool) {

        uint auctionId = auctions.length;

        Auction memory newAuction;

        newAuction.name = _auctionTitle;
        newAuction.blockDeadline = _blockDeadline;
        newAuction.startPrice = _startPrice;
        newAuction.metadata = _metadata;
        newAuction.deedId = _deedId;
        newAuction.deedRepositoryAddress = _deedRepositoryAddress;
        newAuction.owner = msg.sender;
        newAuction.active = true;
        newAuction.finalized = false;

        auctions.push(newAuction);

        auctionOwner[msg.sender].push(auctionId);

        emit AuctionCreated(msg.sender, auctionId);

        return true;
    }

    function approveAndTransfer(address _from, address _to, address _deedRepositoryAddress, uint256 _deedId) internal returns (bool) {

        DeedRepository remoteContract = DeedRepository(_deedRepositoryAddress);

        remoteContract.approve(_to, _deedId);

        remoteContract.transferFrom(_from, _to, _deedId);

        return true;
    }

    function cancelAuction(uint _auctionId) public isOwner(_auctionId) {

        Auction memory auc = auctions[_auctionId];

        uint bidsLength = auctionBids[_auctionId].length;

        if (bidsLength > 0) {

            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];

            if (!lastBid.from.send(lastBid.amount)) {
                revert();
            }
        }

        if (approveAndTransfer(address(this), auc.owner, auc.deedRepositoryAddress, auc.deedId)) {
            
            auctions[_auctionId].active = false;
        
            emit AuctionCanceled(msg.sender, _auctionId);
        }
    }

    function finalizeAuction(uint _auctionId) public {

        Auction memory auc = auctions[_auctionId];

        uint bidsLength = auctionBids[_auctionId].length;

        if (block.timestamp < auc.blockDeadline) {
            revert();
        }

        if (bidsLength == 0) {
            cancelAuction(_auctionId);
        } else {

            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];

            if(!auc.owner.send(lastBid.amount)) {
                revert();
            }

            if (approveAndTransfer(address(this), lastBid.from, auc.deedRepositoryAddress, auc.deedId)) {
                
                auctions[_auctionId].active = false;

                auctions[_auctionId].finalized = true;

                emit AuctionFinalized(msg.sender, _auctionId);
            }
        }
    }

    function bidOnAuction(uint _auctionId) external payable {

        uint256 ethAmountSent = msg.value;

        Auction memory auc = auctions[_auctionId];

        if (auc.owner == msg.sender) {
            revert();
        }

        if (block.timestamp > auc.blockDeadline) {
            revert();
        }

        uint bidsLength = auctionBids[_auctionId].length;

        uint tempAmount = auc.startPrice;

        Bid memory lastBid;

        if (bidsLength > 0) {
            
            lastBid = auctionBids[_auctionId][bidsLength - 1];

            tempAmount = lastBid.amount;
        }

        if (ethAmountSent < tempAmount) {
            revert();
        }

        if (bidsLength > 0) {
            if(!lastBid.from.send(lastBid.amount)) {
                revert();
            }
        }

        Bid memory newBid;

        newBid.from = msg.sender;
        newBid.amount = ethAmountSent;

        auctionBids[_auctionId].push(newBid);

        emit BidSuccess(msg.sender, _auctionId);
    }

    event BidSuccess(address _from, uint _auctionId);

    event AuctionCreated(address _owner, uint _auctionId);

    event AuctionCanceled(address _owner, uint _auctionId);

    event AuctionFinalized(address _owner, uint _auctionId);

}
