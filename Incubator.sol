pragma solidity ^0.8.0;

contract Incubator {
    address public owner;
    address public nftContractAddress;

    struct EggInIncubator {
        uint256 tokenId;
        uint256 startTime;
        bool claimed;
    }

    mapping(address => EggInIncubator[]) public incubatedEggs;

    constructor(address _nftContract) {
        owner = msg.sender;
        nftContractAddress = _nftContract;
    }

    function placeEgg(uint256 tokenId) external payable {
        require(msg.value == 10 ether, "Need to pay $10 USDT equivalent");

        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "Not your egg");

        incubatedEggs[msg.sender].push(EggInIncubator({
            tokenId: tokenId,
            startTime: block.timestamp,
            claimed: false
        }));
    }

    function claimChick(uint256 index) external {
        EggInIncubator storage egg = incubatedEggs[msg.sender][index];
        require(!egg.claimed, "Already claimed");
        require(block.timestamp >= egg.startTime + 30 days, "Not ready yet");

        egg.claimed = true;

        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        nft.mintNFT(msg.sender, "chick", 0); // бессрочно
    }
}
