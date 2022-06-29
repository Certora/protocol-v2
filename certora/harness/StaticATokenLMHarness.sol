// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {StaticATokenLM} from '../../contracts/protocol/tokenization/StaticATokenLM.sol';

/**
 * @title Certora harness for Aave ERC20 StaticATokenLM
 *
 * @dev Certora's harness contract for the verification of Aave ERC20 StaticATokenLM.
 */
contract StaticATokenLMHarness is StaticATokenLM {
    
  function nonces(address owner) public view returns (uint256) {
    return _nonces[owner];
  }

  function metaDeposit(
      address depositor,
      address recipient,
      uint256 value,
      uint16 referralCode,
      bool fromUnderlying,
      uint256 deadline,
      uint8 v,
      bytes32 r,
      bytes32 s      
    ) external returns (uint256) {
      SignatureParams memory sigParams =  SignatureParams(v, r, s);
    return this.metaDeposit(depositor, recipient, value, referralCode, fromUnderlying, deadline, sigParams ); 
  } 

  function metaWithdraw(
      address owner,
      address recipient,
      uint256 staticAmount,
      uint256 dynamicAmount,
      bool toUnderlying,
      uint256 deadline,
      uint8 v,
      bytes32 r,
      bytes32 s 
    ) external returns (uint256, uint256) {
      SignatureParams memory sigParams =  SignatureParams(v, r, s);
      return this.metaWithdraw(owner, recipient, staticAmount, dynamicAmount, toUnderlying, deadline, sigParams ); 
  } 
    
}