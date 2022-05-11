// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {Errors} from '../helpers/Errors.sol';

library RayMathNoRounding {
  uint256 internal constant RAY = 1e27;
  uint256 internal constant WAD_RAY_RATIO = 1e9;

  function rayMulNoRounding(uint256 a, uint256 b) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00800000, 1037618708608) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00800001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00801000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00801001, b) }
    if (a == 0 || b == 0) {
      return 0;
    }
    require(a <= type(uint256).max / b, Errors.MATH_MULTIPLICATION_OVERFLOW);
    return (a * b) / RAY;
  }

  function rayDivNoRounding(uint256 a, uint256 b) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00810000, 1037618708609) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00810001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00811000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00811001, b) }
    require(b != 0, Errors.MATH_DIVISION_BY_ZERO);
    require(a <= (type(uint256).max) / RAY, Errors.MATH_MULTIPLICATION_OVERFLOW);
    return (a * RAY) / b;
  }

  function rayToWadNoRounding(uint256 a) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00820000, 1037618708610) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00820001, 1) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00821000, a) }
    return a / WAD_RAY_RATIO;
  }
}
