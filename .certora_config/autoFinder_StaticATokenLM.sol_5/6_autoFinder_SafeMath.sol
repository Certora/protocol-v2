// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00780000, 1037618708600) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00780001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00781000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00781001, b) }
    uint256 c = a + b;
    require(c >= a, 'SafeMath: addition overflow');

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00790000, 1037618708601) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00790001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00791000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff00791001, b) }
    return sub(a, b, 'SafeMath: subtraction overflow');
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b0000, 1037618708603) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b1000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b1001, b) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007b1002, errorMessage) }
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c0000, 1037618708604) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c1000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007c1001, b) }
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, 'SafeMath: multiplication overflow');

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a0000, 1037618708602) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a1000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007a1001, b) }
    return div(a, b, 'SafeMath: division by zero');
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d0000, 1037618708605) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d1000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d1001, b) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007d1002, errorMessage) }
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e0000, 1037618708606) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e0001, 2) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e1000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007e1001, b) }
    return mod(a, b, 'SafeMath: modulo by zero');
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {assembly { mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f0000, 1037618708607) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f0001, 3) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f1000, a) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f1001, b) mstore(0xffffff6e4604afefe123321beef1b01fffffffffffffffffffffffff007f1002, errorMessage) }
    require(b != 0, errorMessage);
    return a % b;
  }
}
