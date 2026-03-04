// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

/*
@title dTSLA
@author John Paul
 */


contract dTSLA is ConfirmedOwner, FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request; 

    enum MintOrRedeem{
        mint,
        redeem
    }

    struct dTslaRequest{
        uint256 amountOfToken;
        address requester;
        MintOrRedeem mintOrRedeem;
    }

    address constant SEPOLIA_FUNCTIONS_ROUTER = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;
    bytes32 constant DON_ID = hex"66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000";
    uint32 constant GAS_LIMIT = 300_000;
    uint64 immutable i_subId;

    string private s_mintSourceCode;
    uint256 private s_portfolioBalance;
    mapping(bytes32 requestId => dTslaRequest request) private s_requestIdToRequest;

    constructor(string memory mintSourceCode, uint64 subId) ConfirmedOwner(msg.sender) FunctionsClient(SEPOLIA_FUNCTIONS_ROUTER){
        s_mintSourceCode = mintSourceCode;
        i_subId = subId;
    }

    function sendMintRequest(uint256 amount) external onlyOwner returns(bytes32){ 

        FunctionsRequest.Request memory req; 
        req.initializeRequestForInlineJavaScript(s_mintSourceCode); 
        bytes32 requestId = _sendRequest(req.encodeCBOR(), i_subId, GAS_LIMIT, DON_ID); 
        s_requestIdToRequest[requestId] = dTslaRequest(
             amount,
             msg.sender,
            MintOrRedeem.mint
        );
        return requestId;
    }


    function _mintFulfillRequest(bytes32 requestId, bytes memory response) internal{
        uint256 amountToMint = s_requestIdToRequest[requestId].amountOfToken;
        s_portfolioBalance = uint256(bytes32(response)); 

        //if TSLA collateral (how much TSLA we have bought) > dTSLA to mint -> mint dTSLA
        //How much TSLA in $$ do we have
        //how much TSLA in $$ are we minting
    }

    function sendRedeemRequest() external {}

    function _redeemFulfillRequest(bytes32 requestId, bytes memory response) internal {}

    function fulfillRequest(bytes32 requestId, bytes memory response, bytes memory /* err*/) internal override {
        if(s_requestIdToRequest[requestId].mintOrRedeem == MintOrRedeem.mint){
            _mintFulfillRequest(requestId, response);
        } else {
            _redeemFulfillRequest(requestId, response);
        }
    }
    
}