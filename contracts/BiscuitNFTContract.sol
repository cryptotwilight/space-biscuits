// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BiscuitNFTContract is ERC721 {
    
    using Counters for Counters.Counter; 
    Counters.Counter private tokenIds; 
    
    constructor(address _administrator, string memory tokenName, string memory tokenSymbol) ERC721(tokenName, tokenSymbol) {
       // _setBaseURI("ipfs://");        
    }

    function mintToken(address _owner, string memory _metadataURI ) external returns (uint256 _id) {
        tokenIds.increment();
        uint256 tokenId = tokenIds.current();
        _safeMint(_owner, tokenId); 
        //_setTokenURI(tokenId, _metadataURI);
        
        
        return tokenId; 
    }
    
}
