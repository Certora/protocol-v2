certoraRun contracts/protocol/tokenization/StaticATokenLM.sol SymbolicLendingPool AToken DummyERC20A DummyERC20B DummyERC20C 
--link StaticATokenLM:LENDING_POOL=SymbolicLendingPool
 StaticATokenLM:ATOKEN=AToken \
 StaticATokenLM:ASSET=DummyERC20A \
 SymbolicLendingPool:aToken=AToken \
 AToken:_pool=SymbolicLendingPool \
 AToken:_underlyingAsset=DummyERC20A \
--verify  StaticATokenLM:staticATokenLM.spec \
--staging --optimistic_loop --msg "StaticATokenLM"
 