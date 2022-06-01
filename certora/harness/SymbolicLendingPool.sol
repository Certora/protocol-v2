//todo - inhert ERC20 
//add deposit, withdraw, getReserveNormalizedIncome 
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

// import {SafeMath} from '../../contracts/dependencies/openzeppelin/contracts/SafeMath.sol';
import {SafeERC20} from '../../contracts/dependencies/openzeppelin/contracts/SafeERC20.sol';
import "../../contracts/interfaces/IAToken.sol";
contract SymbolicLendingPool  {

    using SafeERC20 for IERC20;

    address aToken; 
    uint256 liquidityIndex = 1; //TODO 
    uint256 data;

    function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external {
    address test = aToken;
    IERC20(asset).safeTransferFrom(msg.sender, aToken, amount);
    IAToken(aToken).mint(onBehalfOf, amount,liquidityIndex );
  }


  function withdraw(
    address asset,
    uint256 amount,
    address to
  ) external  returns (uint256) {
    
    IAToken(aToken).burn(msg.sender, to, amount, liquidityIndex);
    return amount;
  }

  function getReserveNormalizedIncome(address asset)
    external
    view
    virtual
    returns (uint256) {
      return liquidityIndex;
    }

    function finalizeTransfer(
    address asset,
    address from,
    address to,
    uint256 amount,
    uint256 balanceFromAfter,
    uint256 balanceToBefore
    ) external {
    }

    function getATokenAddress(address asset) public returns (address) {
      return aToken;
    }
} 