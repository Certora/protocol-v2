// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import {IERC20} from './IERC20.sol';
import {SafeMath} from './SafeMath.sol';
import { Address } from '/Users/pitanjenny/Work/AAVE-Continues/protocol-v2/contracts/dependencies/openzeppelin/contracts/autoFinder_Address.sol';

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
  using SafeMath for uint256;
  using Address for address;

  function safeTransfer(
    IERC20 token,
    address to,
    uint256 value
  ) internal {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00180000, 1037618708504) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00180001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00181000, token) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00181001, to) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00181002, value) }
    callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
  }

  function safeTransferFrom(
    IERC20 token,
    address from,
    address to,
    uint256 value
  ) internal {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00190000, 1037618708505) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00190001, 4) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00191000, token) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00191001, from) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00191002, to) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00191003, value) }
    callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
  }

  function safeApprove(
    IERC20 token,
    address spender,
    uint256 value
  ) internal {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a0000, 1037618708506) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a1000, token) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a1001, spender) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001a1002, value) }
    require(
      (value == 0) || (token.allowance(address(this), spender) == 0),
      'SafeERC20: approve from non-zero to non-zero allowance'
    );
    callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
  }

  function callOptionalReturn(IERC20 token, bytes memory data) private {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b0000, 1037618708507) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b1000, token) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff001b1001, data) }
    require(address(token).isContract(), 'SafeERC20: call to non-contract');

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = address(token).call(data);
    require(success, 'SafeERC20: low-level call failed');

    if (returndata.length > 0) {
      // Return data is optional
      // solhint-disable-next-line max-line-length
      require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
    }
  }
}
