// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

// import {Pool} from '../../contracts/protocol/pool/Pool.sol';
import {AToken} from '../../contracts/protocol/tokenization/AToken.sol';

/**
 * @title Certora harness for Aave ERC20 AToken
 *
 * @dev Certora's harness contract for the verification of Aave ERC20 AToken.
 */
contract ATokenHarness is AToken {

  function scaledTotalSupply() public view override returns (uint256) {
    uint256 val = super.scaledTotalSupply();
   // POOL.setATokenFlag(!POOL.getATokenFlag());
    return val;
  }

  function getUnderlying() public view returns (address) {
    return _underlyingAsset;
  }

  function getLendingPool() public view returns (address) {
    return address(_pool);
  }
}