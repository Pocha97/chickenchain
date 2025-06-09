// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ChickenChainNFT is ERC721 {
    uint256 public tokenIdCounter;
    
    struct NFTData {
        string nftType; // "egg", "chick", "hen"
        uint256 expirationTime;
        bool isActive;
    }

    mapping(uint256 => NFTData) public tokenData;

    constructor() ERC721("ChickenChain", "CHICK") {}

    function mintNFT(address to, string memory _type, uint256 durationDays) external payable {
        uint256 tokenId = tokenIdCounter++;
        _mint(to, tokenId);

        uint256 expiration = block.timestamp + durationDays * 1 days;
        tokenData[tokenId] = NFTData(_type, expiration, true);
    }

    function isExpired(uint256 tokenId) public view returns (bool) {
        return block.timestamp > tokenData[tokenId].expirationTime;
    }

    function burnIfExpired(uint256 tokenId) external {
        require(isExpired(tokenId), "Not expired yet");
        _burn(tokenId);
    }
}
