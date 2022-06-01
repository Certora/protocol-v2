// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

// import {SafeERC20} from '@aave/aave-stake/contracts/lib/SafeERC20.sol';
// import {SafeMath} from '../lib/SafeMath.sol';
// import {DistributionTypes} from '../lib/DistributionTypes.sol';
// import {VersionedInitializable} from '@aave/aave-stake/contracts/utils/VersionedInitializable.sol';
// import {DistributionManager} from './DistributionManager.sol';
// import {IStakedTokenWithConfig} from '../interfaces/IStakedTokenWithConfig.sol';
// import {IERC20} from '@aave/aave-stake/contracts/interfaces/IERC20.sol';
// import {IScaledBalanceToken} from '../interfaces/IScaledBalanceToken.sol';
// import {IAaveIncentivesController} from '../interfaces/IAaveIncentivesController.sol';


// import {SafeERC20} from '../../contracts/dependencies/openzeppelin/contracts/SafeERC20.sol';
import "../harness/IERC20.sol";

/**
 * @title StakedTokenIncentivesController
 * @notice Distributor contract for rewards to the Aave protocol, using a staked token as rewards asset.
 * The contract stakes the rewards before redistributing them to the Aave protocol participants.
 * The reference staked token implementation is at https://github.com/aave/aave-stake-v2
 * @author Aave
 **/
contract IncentivesController
{
  // using SafeERC20 for IERC20;

  uint256 public constant REVISION = 1;

  IERC20 public REWARD_TOKEN;
  address user;

  uint256 _distributionEnd;
  uint256 amountToClaim;

  uint104 emissionPerSecond;
  uint104 index;
  uint40 lastUpdateTimestamp;

  event CallData(bytes);
  function getRewardsBalance(address[] calldata assets, address user)
    external view returns (uint256) {
    return amountToClaim;
  }

  function claimRewards(
    address[] calldata assets,
    uint256 amount,
    address to
  ) external returns (uint256) {
    require(to != address(0), 'INVALID_TO_ADDRESS');
    REWARD_TOKEN.transfer(address(this), amountToClaim);
    return amountToClaim;
  }

  function getClaimer(address user) external view returns (address) {
    return user;
  }

  function DISTRIBUTION_END() external view returns (uint256) {
    return _distributionEnd;
  }

  function getAssetData(address asset) public view returns (uint256, uint256, uint256) {
    return (index, emissionPerSecond, lastUpdateTimestamp);
  }
}
