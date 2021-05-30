pragma solidity >=0.7.0 <=0.9.0;


import "./ChainlinkBroker.sol";
import "./BiscuitManager.sol";


contract SpaceBiscuits { 
    

  uint256 avaialbleBiscuitCount; 
  address administrator; 
  ChainlinkBroker chainlink; 
  BiscuitManager spaceBiscuits; 
  
  mapping(uint256=>string) spacebiscuitThumbnailsByBiscuitId; 
  
  mapping(address=>uint256[]) spaceBiscuitsByWalletAddress;
  
  uint256 availbleBiscuitCount;
  
  
  mapping(uint256=>bool) availabilityByBiscuitId; 
  
  
  constructor(address _administrator, address _chainlinkBrokerAddress, address _biscuitManager) {
      administrator = _administrator; 
      chainlink = ChainlinkBroker(_chainlinkBrokerAddress);
      spaceBiscuits = BiscuitManager(_biscuitManager);
  }
  
    
  function getLatestBiscuit() external returns (uint256 _biscuitId, string memory _biscuitThumbnail) {
      bytes32 requestId = chainlink.getLatestBiscuit(); 
      
  }

    
  function getWalletBiscuits() external view returns (uint256 [] _biscuitIds, string memory _biscuitThumbnails) {
      
  }    

  function buySpaceBiscuit(uint256 _biscuitId) external payable returns (uint256 [] _biscuitIds, address _holder) {
  
  }

} 

