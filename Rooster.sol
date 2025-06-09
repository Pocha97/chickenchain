pragma solidity ^0.8.0;

contract Rooster {
    address public owner;
    address public nftContractAddress;

    struct HenWithRooster {
        uint256 tokenId;
        uint256 activationTime;
        uint256 eggsProduced;
    }

    mapping(address => HenWithRooster[]) public activeHens;

    constructor(address _nftContract) {
        owner = msg.sender;
        nftContractAddress = _nftContract;
    }

    function activateHen(uint256 tokenId) external payable {
        require(msg.value == 5 ether, "Need to pay $5 USDT equivalent");

        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "Not your hen");

        activeHens[msg.sender].push(HenWithRooster({
            tokenId: tokenId,
            activationTime: block.timestamp,
            eggsProduced: 0
        }));
    }

    function produceEgg(uint256 index) external {
        HenWithRooster storage hen = activeHens[msg.sender][index];
        require(hen.eggsProduced < 90, "Hen has produced enough eggs");
        require(block.timestamp <= hen.activationTime + 30 days, "Activation period ended");

        // Увеличиваем счетчик
        hen.eggsProduced += 1;

        // Минтер должен быть вызван из контракта
        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        nft.mintNFT(msg.sender, "egg", 30); // 30 дней жизни
    }
}
