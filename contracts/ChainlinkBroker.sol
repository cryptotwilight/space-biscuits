// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;


import "./IERC20.sol";
import "@chainlink/contracts/src/v0.7/Chainlink.sol";
import "@chainlink/contracts/src/v0.7/ChainlinkClient.sol";

//import "./BiscuitManager.sol";

contract ChainlinkBroker is ChainlinkClient { 
  
    using Chainlink for Chainlink.Request; 
  
    address administrator;
    uint256 multiplier = 10 ** 18; 
    address oracle; 
    bytes32 jobId;
    uint256 fee; 
    
    uint256 count; 
    
    string missionName; 
    
  //  BiscuitManager spaceBiscuits; 
    
    IERC20 LINK; 
    mapping(bytes32=>string) requestIdStringByRequestIdBytes32; 
    mapping(string=>bytes32) requestIdBytes32ByRequestIdString; 
    mapping(string=>string) missionNameByRequestId; 
    
    string [] allRequestIds; 
    string [] allMissionNames; 
    bytes32 [] allReqIds; 
    
    constructor(address _administrator, 
                address _oracleAddress, 
                address _linkAddress,
                uint256 _fee )  { 
        setPublicChainlinkToken();
        oracle = _oracleAddress; 
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = _fee ; 
        administrator = _administrator; 
        LINK = IERC20(_linkAddress);
        LINK.approve(_oracleAddress, fee);
    }
    
    function requestMissionData() public returns (bytes32 _requestId) {
        
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        request.add("get", "https://api.spacexdata.com/v2/launches");
        
        request.add("path", "-1.mission_name");
        
        //request.addInt("times", multiplier);
        bytes32 reqIdb = sendChainlinkRequestTo(oracle, request, fee);
       
        allReqIds.push(reqIdb);
       
        string memory reqId = bytes32ToString(reqIdb);
        
        allRequestIds.push(reqId);
        
        return reqIdb;
    }
    
    function postImageData() external returns (bytes32 _requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.notifyPosted.selector);
        
        request.add("get", "https://blockstarlogic.com/spacebiscuitsweb_0_0_2");
        
        request.add("path", "fulfilled");
        
        //request.addInt("times", multiplier);
        bytes32 reqIdb = sendChainlinkRequestTo(oracle, request, fee);
       
        allReqIds.push(reqIdb);
       
        string memory reqId = bytes32ToString(reqIdb);
        
        allRequestIds.push(reqId);
        
        return reqIdb;
    }
    
    function getFulfilledRequestCount()  external view returns (uint256 _fulfilledRequestCount) {
        return count; 
    }

    function getMissionName(string memory _requestId) external view returns (string memory _missionName ){
        return  missionNameByRequestId[_requestId];
    }

    function getJobId() external view returns (bytes32 _jobId){
        return jobId;
    }
    
    function getAllRawRequestIds() external view returns (bytes32 [] memory _requestIds) {
        return allReqIds;
    }

    function getAllRequestIds() external view returns (string [] memory _requestIds) {
        return allRequestIds;
    }

    function getAllMissionNames() external view returns (string [] memory _missionNames) {
        return allMissionNames; 
    }

    function fulfill(bytes32 _requestId, string memory _missionName)  public recordChainlinkFulfillment(_requestId){
        string memory reqId = requestIdStringByRequestIdBytes32[_requestId];
        allMissionNames.push(_missionName);
        missionNameByRequestId[reqId] = _missionName;
        
        //spacebiscuits.createNewBiscuit();
        
        
        count++;
    }
    
    function notifyPosted(bytes32 _requestId, string memory _responseStatus)  public recordChainlinkFulfillment(_requestId){
        string memory reqId = requestIdStringByRequestIdBytes32[_requestId];
    
            
        
        count++;
    }
    
    
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
    
        assembly {
            result := mload(add(source, 32))
        }
    }
    
    function creditLink(uint256 _link) external returns (uint256 _balance) {
        LINK.transferFrom(msg.sender, address(this), _link*multiplier);
        return this.getLINKBalance(); 
    }
    
    function getLINKBalance() external view returns (uint256 _balance) {
        return LINK.balanceOf(address(this));
    }
    
    function withdrawLINK() external returns (bool _done) {
        LINK.transfer(msg.sender, this.getLINKBalance());
        return true; 
    }
    
    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    function setBiscuitManager(address _biscuitManager) external returns (bool _set) {
        require(msg.sender == administrator, "administrator only");
        //spacebiscuits = _biscuitManager(_biscuitManager);
    }

    
} 
