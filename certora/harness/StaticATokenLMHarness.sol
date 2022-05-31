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

  // constructor() public StaticATokenLM() {    
  // }
    
  function nonces(address owner) public view returns (uint256) {
    return _nonces[owner];
  }


  // function metaDeposit(
  //   address depositor,
  //   address recipient,
  //   uint256 value,
  //   uint16 referralCode,
  //   bool fromUnderlying,
  //   uint256 deadline,
  //   uint8 _v,
  //   bytes32 _r,
  //   bytes32 _s
  // ) public returns (uint256) {
  //   SignatureParams memory sigParams = SignatureParams({v: _v, r: _r, s: _s});
  //   // return super.deposit(recipient, value, referralCode, fromUnderlying );
  //   return super.metaDeposit(depositor, recipient, value, referralCode, fromUnderlying, deadline, sigParams);
  // }

  // function metaWithdraw_(
  //   address owner,
  //   address recipient,
  //   uint256 staticAmount,
  //   uint256 dynamicAmount,
  //   bool toUnderlying,
  //   uint256 deadline,
  //   uint8 _v,
  //   bytes32 _r,
  //   bytes32 _s
  // ) external returns (uint256, uint256) {
  //   SignatureParams memory sigParams = SignatureParams({v: _v, r: _r, s: _s});
  //   return super.metaWithdraw(owner, recipient, staticAmount, dynamicAmount, toUnderlying, deadline, sigParams);
  // }

  // function initialize(
  //     ILendingPool pool,
  //     address aToken,
  //     string calldata staticATokenName,
  //     string calldata staticATokenSymbol,
  //     address l1TokenBridge
  //   ) external override initializer {
  //   super.initialize(ILendingPool pool, aToken, staticATokenName, staticATokenSymbol, l1TokenBridge ); 
  // } 

  // function deposit_call(
  //     address recipient,
  //     uint256 amount,
  //     uint16 referralCode,
  //     bool fromUnderlying
  //   ) external returns (uint256) {
  //   return deposit(recipient, amount, referralCode, fromUnderlying ); 
  // } 

  // function withdraw(
  //     address recipient,
  //     uint256 amount,
  //     bool toUnderlying
  //   ) external override returns (uint256, uint256) {
  //   return super.withdraw(recipient, amount, toUnderlying ); 
  // } 

  // function withdrawDynamicAmount(
  //     address recipient,
  //     uint256 amount,
  //     bool toUnderlying
  //   ) external override returns (uint256, uint256) {
  //   return super.withdrawDynamicAmount(recipient, amount, toUnderlying ); 
  // } 

  // function permit(
  //     address owner,
  //     address spender,
  //     uint256 value,
  //     uint256 deadline,
  //     uint8 v,
  //     bytes32 r,
  //     bytes32 s
  //   ) external override {
  //   super.permit(owner, spender, value, deadline, v, r, s ); 
  // } 

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

  // function dynamicBalanceOf(address account) external view override returns (uint256) {
  //   return super.dynamicBalanceOf(account); 
  // } 

  // function staticToDynamicAmount(uint256 amount) external view override returns (uint256) {
  //   return super.staticToDynamicAmount(amount); 
  // } 

  // function dynamicToStaticAmount(uint256 amount) external view override returns (uint256) {
  //   return super.dynamicToStaticAmount(amount); 
  // } 

  // function rate() public view override returns (uint256) {
  //   return super.rate(); 
  // } 

  // function getDomainSeparator() public view override returns (bytes32) {
  //   return super.getDomainSeparator(); 
  // } 

  // function collectAndUpdateRewards() public override returns (uint256) {
  //   return super.collectAndUpdateRewards(); 
  // } 

  // function claimRewardsOnBehalf(address onBehalfOf, address receiver) external override {
  //   super.claimRewardsOnBehalf(onBehalfOf, receiver); 
  // } 

  // function claimRewards(address receiver) external override {
  //   super.claimRewards(receiver); 
  // } 

  // function claimRewardsToSelf() external override {
  //   super.claimRewardsToSelf(); 
  // } 

  // function _getCurrentRewardsIndex() public view returns (uint256) {
  //   return super._getCurrentRewardsIndex(); 
  // } 

  // function getTotalClaimableRewards() external view override returns (uint256) {
  //   return super.getTotalClaimableRewards(); 
  // } 

  // function getClaimableRewards(address user) external view override returns (uint256) {
  //   return super.getClaimableRewards(user); 
  // } 

  // function getUnclaimedRewards(address user) external view override returns (uint256) {
  //   return super.getUnclaimedRewards(user); 
  // } 

  // function getAccRewardsPerToken() external view override returns (uint256) {
  //   return super.getAccRewardsPerToken(); 
  // } 

  // function getLifetimeRewardsClaimed() external view override returns (uint256) {
  //   return super.getLifetimeRewardsClaimed(); 
  // } 

  // function getLifetimeRewards() external view override returns (uint256) {
  //   return super.getLifetimeRewards(); 
  // } 

  // function getLastRewardBlock() external view override returns (uint256) {
  //   return super.getLastRewardBlock(); 
  // } 

  // function getIncentivesController() external view override returns (IAaveIncentivesController) {
  //   return super.getIncentivesController(); 
  // } 

  // function UNDERLYING_ASSET_ADDRESS() external view override returns (address) {
  //   return super.UNDERLYING_ASSET_ADDRESS(); 
  // } 

    
}