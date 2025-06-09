pragma solidity ^0.8.0;

contract Farm {
    address public owner;
    address public nftContractAddress;

    struct ChickOnFarm {
        uint256 tokenId;
        uint256 startTime;
        bool claimed;
    }

    mapping(address => ChickOnFarm[]) public farmedChicks;

    constructor(address _nftContract) {
        owner = msg.sender;
        nftContractAddress = _nftContract;
    }

    function placeChick(uint256 tokenId) external payable {
        require(msg.value == 10 ether, "Need to pay $10 USDT equivalent");

        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "Not your chick");

        farmedChicks[msg.sender].push(ChickOnFarm({
            tokenId: tokenId,
            startTime: block.timestamp,
            claimed: false
        }));
    }

    function claimHen(uint256 index) external {
        ChickOnFarm storage chick = farmedChicks[msg.sender][index];
        require(!chick.claimed, "Already claimed");
        require(block.timestamp >= chick.startTime + 30 days, "Not ready yet");

        chick.claimed = true;

        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        nft.mintNFT(msg.sender, "hen", 0); // бессрочно
    }
}
