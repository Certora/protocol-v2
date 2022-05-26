certoraRun contracts/protocol/tokenization/StaticATokenLM.sol contracts/protocol/tokenization/AToken.sol certora/harness/SymbolicLendingPool.sol certora/harness/DummyERC20A.sol certora/harness/DummyERC20B.sol certora/harness/DummyERC20C.sol \
    --verify StaticATokenLM:certora/specs/staticAtokenLM.spec \
    --link StaticATokenLM:LENDING_POOL=SymbolicLendingPool \
    StaticATokenLM:ATOKEN=AToken \
    StaticATokenLM:ASSET=DummyERC20B \
    SymbolicLendingPool:aToken=AToken \
    AToken:_pool=SymbolicLendingPool \
    AToken:_underlyingAsset=DummyERC20C \
    --solc solc6.12 \
    --optimistic_loop \
    --msg "StaticATokenLM"