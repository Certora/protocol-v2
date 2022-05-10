//todo - inhert ERC20 
//add deposit, withdraw, getReserveNormalizedIncome 
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./IERC20.sol";
import {SafeMath} from '../../contracts/dependencies/openzeppelin/contracts/SafeMath.sol';
import "../../contracts/interfaces/IAToken.sol"
contract SymbolicLendingPool  {

    address aToken; 
    uint256 liquidityIndex = 1; //TODO 
    function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external {
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
    override
    returns (uint256) {
      return liquidityIndex;
    }

} 