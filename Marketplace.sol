pragma solidity ^0.8.0;

contract Marketplace {
    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;
    }

    Listing[] public listings;

    address public nftContractAddress;

    constructor(address _nftContract) {
        nftContractAddress = _nftContract;
    }

    function listNFT(uint256 tokenId, uint256 price) external {
        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "You don't own this NFT");

        listings.push(Listing({
            seller: msg.sender,
            tokenId: tokenId,
            price: price
        }));
    }

    function buyNFT(uint256 listingIndex) external payable {
        Listing storage listing = listings[listingIndex];
        require(msg.value >= listing.price, "Not enough funds");

        ChickenChainNFT nft = ChickenChainNFT(nftContractAddress);
        nft.transferFrom(listing.seller, msg.sender, listing.tokenId);

        payable(listing.seller).transfer(msg.value);
    }
}
