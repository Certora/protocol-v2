certoraRun certora/harness/StaticATokenLMHarness.sol certora/harness/ATokenHarness.sol certora/harness/SymbolicLendingPool.sol certora/harness/DummyERC20A.sol certora/harness/DummyERC20B.sol certora/harness/DummyERC20C.sol certora/harness/IncentivesController.sol \
           --verify StaticATokenLMHarness:certora/specs/staticAtokenLM.spec \
           --link StaticATokenLMHarness:LENDING_POOL=SymbolicLendingPool StaticATokenLMHarness:ATOKEN=ATokenHarness StaticATokenLMHarness:ASSET=DummyERC20B StaticATokenLMHarness:REWARD_TOKEN=DummyERC20A StaticATokenLMHarness:INCENTIVES_CONTROLLER=IncentivesController SymbolicLendingPool:aToken=ATokenHarness ATokenHarness:_pool=SymbolicLendingPool ATokenHarness:_underlyingAsset=DummyERC20B \
           --solc solc6.12 \
           --optimistic_loop \
           --msg "StaticATokenLM"