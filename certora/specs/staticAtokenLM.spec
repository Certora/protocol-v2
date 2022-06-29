using DummyERC20A as REWARD_TOKEN
using DummyERC20B as ASSET
using ATokenHarness as ATOKEN
using SymbolicLendingPool as LENDING_POOL
using IncentivesController as INCENTIVES_CONTROLLER

methods {
	// StaticATokenLM
	nonces(address) returns(uint256) envfree;
	allowance(address, address) returns(uint256) envfree;
	rate() returns(uint256);
	balanceOf(address) returns(uint256) envfree => DISPATCHER(true);
	sendMessageStaticAToken(uint256) => NONDET;
	
	// IVariableDebtToken
	scaledTotalSupply() => NONDET;
	
	calculateInterestRates(address, uint256, uint256, uint256,
		uint256, uint256) => NONDET;
	
	calculateInterestRates(address, address, uint256, uint256,
		uint256, uint256, uint256, uint256) => NONDET;
	
	// IStableDebtToken
	getTotalSupplyAndAvgRate() returns(uint256, uint256) => NONDET;
	getSupplyData() returns(uint256, uint256, uint256, uint40) => NONDET;
	
	// asset
	ASSET.balanceOf(address user) returns(uint256) envfree;
	
	// AToken
	mint(address user, uint256 amount, uint256 index) returns(bool) => DISPATCHER(true);
	burn(address user, address receiverOfUnderlying, uint256 amount, uint256 index) => DISPATCHER(true);
	mintToTreasury(uint256 amount, uint256 index) => DISPATCHER(true);
	
	ATOKEN.balanceOf(address user) returns(uint256) envfree;
	ATOKEN.getUnderlying() returns(address) envfree;
	ATOKEN.getLendingPool() returns(address) envfree;
	
	REWARD_TOKEN.balanceOf(address user) returns(uint256) envfree;
	INCENTIVES_CONTROLLER.REWARD_TOKEN() envfree;

	// LendingPool
	LENDING_POOL.getATokenAddress(address) returns(address) envfree;
	LENDING_POOL.deposit(address, uint256, address, uint16);
	LENDING_POOL.withdraw(address, uint256, address) returns(uint256);
	getLendingPoolCollateralManager() returns(address) => NONDET;
	getPriceOracle() => NONDET;
	// getReserveNormalizedIncome(address u) returns (uint256) => gRNI()
	
	handleAction(address asset, uint256 userBalance, uint256 totalSupply) => NONDET;
	finalizeTransfer(address asset, address from, address to, uint256 amount, uint256 balanceFromAfter, uint256 balanceToBefore) => NONDET;
	getReserveNormalizedIncome(address u) returns(uint256) => gRNI();
	
	raymul(uint x, uint y ) => identity(x, y);
    raydiv(uint x, uint y ) => identity(x, y);

	// INCENTIVES_CONTROLLER
	DISTRIBUTION_END() returns (uint256) => DISPATCHER(true)
	REWARD_TOKEN() returns (address) => DISPATCHER(true)
	getClaimer(address user) returns (address) => DISPATCHER(true)
	claimRewards(address[] assets, uint256 amount, address to) returns (uint256) => DISPATCHER(true)
	getRewardsBalance(address[] assets, address user) returns (uint256) => DISPATCHER(true)
	getAssetData(address asset) returns (uint256, uint256, uint256) => DISPATCHER(true)
	collectAndUpdateRewards() returns (uint256)

	metaDeposit( address depositor, address recipient, uint256 value, uint16 referralCode, bool fromUnderlying, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns(uint256);
	metaWithdraw( address owner, address recipient, uint256 staticAmount, uint256 dynamicAmount, bool toUnderlying, uint256 deadline, uint8 v, bytes32 r, bytes32 s ) returns(uint256, uint256);
}

definition MAX_UINT256() returns uint256 =
	0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
definition ray() returns uint = 1000000000000000000000000000;
definition half_ray() returns uint = ray() / 2;
definition bounded_error_eq(uint x, uint y, uint epsilon) returns bool = x <= y + epsilon && x + epsilon >= y;

function identity (uint x, uint y) returns uint{
	return x;
}

ghost gRNI() returns uint256 {
	// axiom gRNI() == ray() + (ray() / 2);
	axiom gRNI() == ray();
}


function setup(env e, address recipient) {
	require ASSET == ATOKEN.getUnderlying();
	require LENDING_POOL == ATOKEN.getLendingPool();
	require ATOKEN == LENDING_POOL.getATokenAddress(ASSET);
	require rate(e) > 0;
	require e.msg.sender != recipient && recipient != currentContract && e.msg.sender != currentContract;
	require e.msg.sender != ATOKEN && e.msg.sender != ASSET && e.msg.sender != LENDING_POOL;
	// can we always safely assume this?
	require recipient != ATOKEN && recipient != ASSET && recipient != LENDING_POOL;
	require REWARD_TOKEN == INCENTIVES_CONTROLLER.REWARD_TOKEN();
}

rule depositIntegrity(address depositor, address recipient, uint256 amount, uint16 referralCode, bool fromUnderlying, uint256 deadline, uint8 v, bytes32 r, bytes32 s, method f)
filtered {
	f -> f.selector == deposit(address, uint256, uint16, bool).selector
	 || f.selector == metaDeposit(address, address, uint256, uint16, bool, uint256, uint8, bytes32, bytes32).selector
	}
{
	env e;
	setup(e, recipient);
	require e.msg.sender == depositor;
	
	uint256 _assetBySender = ASSET.balanceOf(e.msg.sender);
	uint256 _assetByRecipient = ASSET.balanceOf(recipient);
	uint256 _assetByStaticAToken = ASSET.balanceOf(currentContract);
	uint256 _assetByAToken = ASSET.balanceOf(ATOKEN);
	
	uint256 _staticATokenBySender = balanceOf(e.msg.sender);
	uint256 _staticATokenByRecipient = balanceOf(recipient);
	
	uint256 _aTokenBySender = ATOKEN.balanceOf(e.msg.sender);
	uint256 _aTokenByRecipient = ATOKEN.balanceOf(recipient);
	uint256 _aTokenByStaticAToken = ATOKEN.balanceOf(currentContract);
	
	uint256 _nonce = nonces(depositor);

	require amount > 0;
	if (f.selector == deposit(address, uint256, uint16, bool).selector) {
		deposit(e, recipient, amount, referralCode, fromUnderlying);
	}
	else {
		metaDeposit(e, depositor, recipient, amount, referralCode, fromUnderlying, deadline, v, r, s);
	}	
	
	uint256 assetBySender_ = ASSET.balanceOf(e.msg.sender);
	uint256 assetByRecipient_ = ASSET.balanceOf(recipient);
	uint256 assetByStaticAToken_ = ASSET.balanceOf(currentContract);
	uint256 assetByAToken_ = ASSET.balanceOf(ATOKEN);
	
	uint256 staticATokenBySender_ = balanceOf(e.msg.sender);
	uint256 staticATokenByRecipient_ = balanceOf(recipient);
	
	uint256 aTokenBySender_ = ATOKEN.balanceOf(e.msg.sender);
	uint256 aTokenByRecipient_ = ATOKEN.balanceOf(recipient);
	uint256 aTokenByStaticAToken_ = ATOKEN.balanceOf(currentContract);
	
	assert _assetBySender > 0 && fromUnderlying => assetBySender_ < _assetBySender && assetByAToken_ > _assetByAToken && aTokenBySender_ == _aTokenBySender;
	assert _aTokenBySender > 0 && !fromUnderlying => assetBySender_ == _assetBySender && assetByAToken_ == _assetByAToken && aTokenBySender_ < _aTokenBySender;
	assert assetByStaticAToken_ == _assetByStaticAToken && aTokenByStaticAToken_ > _aTokenByStaticAToken;
	assert staticATokenByRecipient_ > _staticATokenByRecipient;
	assert assetByRecipient_ == _assetByRecipient;
	assert e.msg.sender != recipient => staticATokenBySender_ == _staticATokenBySender && aTokenByRecipient_ == _aTokenByRecipient;

	if (f.selector == deposit(address, uint256, uint16, bool).selector) {
		assert nonces(depositor) == _nonce;
	} else {
		assert nonces(depositor) == _nonce + 1;
	}
}

rule depositAdditivity(address recipient, uint256 amount1, uint256 amount2, uint16 referralCode, bool fromUnderlying) {
	env e;
	setup(e, recipient);
	
	storage init = lastStorage;
	uint amount = amount1 + amount2;
	require amount1 > 0 && amount2 > 0 && (amount <= MAX_UINT256());
	deposit(e, recipient, amount1, referralCode, fromUnderlying);
	deposit(e, recipient, amount2, referralCode, fromUnderlying);
	
	uint256 _assetBySender = ASSET.balanceOf(e.msg.sender);
	uint256 _assetByRecipient = ASSET.balanceOf(recipient);
	uint256 _assetByStaticAToken = ASSET.balanceOf(currentContract);
	uint256 _assetByAToken = ASSET.balanceOf(ATOKEN);
	
	uint256 _staticATokenBySender = balanceOf(e.msg.sender);
	uint256 _staticATokenByRecipient = balanceOf(recipient);
	
	uint256 _aTokenBySender = ATOKEN.balanceOf(e.msg.sender);
	uint256 _aTokenByRecipient = ATOKEN.balanceOf(recipient);
	uint256 _aTokenByStaticAToken = ATOKEN.balanceOf(currentContract);

	deposit(e, recipient, amount, referralCode, fromUnderlying) at init;

	uint256 assetBySender_ = ASSET.balanceOf(e.msg.sender);
	uint256 assetByRecipient_ = ASSET.balanceOf(recipient);
	uint256 assetByStaticAToken_ = ASSET.balanceOf(currentContract);
	uint256 assetByAToken_ = ASSET.balanceOf(ATOKEN);
	
	uint256 staticATokenBySender_ = balanceOf(e.msg.sender);
	uint256 staticATokenByRecipient_ = balanceOf(recipient);
	
	uint256 aTokenBySender_ = ATOKEN.balanceOf(e.msg.sender);
	uint256 aTokenByRecipient_ = ATOKEN.balanceOf(recipient);
	uint256 aTokenByStaticAToken_ = ATOKEN.balanceOf(currentContract);
	
	assert assetBySender_ == _assetBySender && assetByAToken_ == _assetByAToken && aTokenBySender_ == _aTokenBySender;
	assert assetByStaticAToken_ == _assetByStaticAToken && aTokenByStaticAToken_ == _aTokenByStaticAToken;
	assert staticATokenByRecipient_ == _staticATokenByRecipient;
	assert assetByRecipient_ == _assetByRecipient;
	assert staticATokenBySender_ == _staticATokenBySender && aTokenByRecipient_ == _aTokenByRecipient;
}


rule depositNoInterfernece(address recipient, address other, uint256 amount, uint16 referralCode, bool fromUnderlying) {
	env e;
	setup(e, recipient);
	setup(e, other);
	require recipient != other;
	
	uint256 _assetByOther = ASSET.balanceOf(other);
	uint256 _staticATokenByOther = balanceOf(other);
	uint256 _aTokenByOther = ATOKEN.balanceOf(other);
	
	deposit(e, recipient, amount, referralCode, fromUnderlying);

	uint256 assetByOther_ = ASSET.balanceOf(other);
	uint256 staticATokenByOther_ = balanceOf(other);
	uint256 aTokenByOther_ = ATOKEN.balanceOf(other);

	assert _assetByOther == assetByOther_ && _staticATokenByOther == staticATokenByOther_ && 	_aTokenByOther == aTokenByOther_;
}

rule withdrawIntegrity(address owner, address recipient, uint256 staticAmount, uint256 dynamicAmount, bool toUnderlying, uint256 deadline, uint8 v, bytes32 r, bytes32 s, method f) filtered {
	f -> f.selector == withdraw(address, uint256, bool).selector ||
		f.selector == withdrawDynamicAmount(address, uint256, bool).selector 
		|| f.selector == metaWithdraw(address, address, uint256, uint256, bool, uint256, uint8, bytes32, bytes32).selector 
	}
{
	env e;
	setup(e, recipient);
	require e.msg.sender == owner;
	uint amount = staticAmount + dynamicAmount;
	require (staticAmount==0 && dynamicAmount>0) || (staticAmount>0 && dynamicAmount==0);

	uint256 _assetBySender = ASSET.balanceOf(e.msg.sender);
	uint256 _assetByRecipient = ASSET.balanceOf(recipient);
	uint256 _assetByStaticAToken = ASSET.balanceOf(currentContract);
	uint256 _assetByAToken = ASSET.balanceOf(ATOKEN);
	
	uint256 _staticATokenBySender = balanceOf(e.msg.sender);
	uint256 _staticATokenByRecipient = balanceOf(recipient);
	
	uint256 _aTokenBySender = ATOKEN.balanceOf(e.msg.sender);
	uint256 _aTokenByRecipient = ATOKEN.balanceOf(recipient);
	uint256 _aTokenByStaticAToken = ATOKEN.balanceOf(currentContract);
	
	uint256 _nonce = nonces(owner);

	require amount > 0;
	if (f.selector == withdraw(address, uint256, bool).selector) {
		withdraw(e, recipient, amount, toUnderlying);
	} else if (f.selector == withdrawDynamicAmount(address, uint256, bool).selector) {
		withdrawDynamicAmount(e, recipient, amount, toUnderlying);
	} else {
		metaWithdraw(e, owner, recipient,  staticAmount, dynamicAmount, toUnderlying, deadline, v, r, s);
	}
	uint256 assetBySender_ = ASSET.balanceOf(e.msg.sender);
	uint256 assetByRecipient_ = ASSET.balanceOf(recipient);
	uint256 assetByStaticAToken_ = ASSET.balanceOf(currentContract);
	uint256 assetByAToken_ = ASSET.balanceOf(ATOKEN);
	
	uint256 staticATokenBySender_ = balanceOf(e.msg.sender);
	uint256 staticATokenByRecipient_ = balanceOf(recipient);
	
	uint256 aTokenBySender_ = ATOKEN.balanceOf(e.msg.sender);
	uint256 aTokenByRecipient_ = ATOKEN.balanceOf(recipient);
	uint256 aTokenByStaticAToken_ = ATOKEN.balanceOf(currentContract);
	
	assert _staticATokenBySender > 0 && toUnderlying => assetByRecipient_ > _assetByRecipient && assetByAToken_ < _assetByAToken;
	assert _staticATokenBySender > 0 && !toUnderlying => aTokenByRecipient_ > _aTokenByRecipient;
	assert _staticATokenBySender > 0 => aTokenByStaticAToken_ < _aTokenByStaticAToken && staticATokenBySender_ < _staticATokenBySender;
	assert assetByStaticAToken_ == _assetByStaticAToken;
	assert e.msg.sender != recipient => aTokenBySender_ == _aTokenBySender && assetBySender_ == _assetBySender && staticATokenByRecipient_ == _staticATokenByRecipient;

	if (f.selector == withdraw(address, uint256, bool).selector || f.selector == withdrawDynamicAmount(address, uint256, bool).selector) {
		assert nonces(owner) == _nonce;
	} else {
		assert nonces(owner) == _nonce + 1;
	}
}

rule withdrawAdditivity(address recipient, uint256 amount1, uint256 amount2, bool toUnderlying, method f) filtered {
	f -> f.selector == withdraw(address, uint256, bool).selector ||
		f.selector == withdrawDynamicAmount(address, uint256, bool).selector
	}
{
	env e;
	setup(e, recipient);
	require amount1 > 0 && amount2 > 0 && (amount1 + amount2 <= MAX_UINT256());
	
	storage init = lastStorage;
	if (f.selector == withdraw(address, uint256, bool).selector) {
		withdraw(e, recipient, amount1, toUnderlying);
		withdraw(e, recipient, amount2, toUnderlying);
	}
	else {
		withdrawDynamicAmount(e, recipient, amount1, toUnderlying);
		withdrawDynamicAmount(e, recipient, amount2, toUnderlying);
	}

	uint256 _assetBySender = ASSET.balanceOf(e.msg.sender);
	uint256 _assetByRecipient = ASSET.balanceOf(recipient);
	uint256 _assetByStaticAToken = ASSET.balanceOf(currentContract);
	uint256 _assetByAToken = ASSET.balanceOf(ATOKEN);
	
	uint256 _staticATokenBySender = balanceOf(e.msg.sender);
	uint256 _staticATokenByRecipient = balanceOf(recipient);
	
	uint256 _aTokenBySender = ATOKEN.balanceOf(e.msg.sender);
	uint256 _aTokenByRecipient = ATOKEN.balanceOf(recipient);
	uint256 _aTokenByStaticAToken = ATOKEN.balanceOf(currentContract);
	
	require amount1 > 0 && amount2 > 0;
	if (f.selector == withdraw(address, uint256, bool).selector) {
		withdraw(e, recipient, amount1 + amount2, toUnderlying);
	}
	else {
		withdrawDynamicAmount(e, recipient, amount1 + amount2, toUnderlying);
	}
	uint256 assetBySender_ = ASSET.balanceOf(e.msg.sender);
	uint256 assetByRecipient_ = ASSET.balanceOf(recipient);
	uint256 assetByStaticAToken_ = ASSET.balanceOf(currentContract);
	uint256 assetByAToken_ = ASSET.balanceOf(ATOKEN);
	
	uint256 staticATokenBySender_ = balanceOf(e.msg.sender);
	uint256 staticATokenByRecipient_ = balanceOf(recipient);
	
	uint256 aTokenBySender_ = ATOKEN.balanceOf(e.msg.sender);
	uint256 aTokenByRecipient_ = ATOKEN.balanceOf(recipient);
	uint256 aTokenByStaticAToken_ = ATOKEN.balanceOf(currentContract);
	
	assert _staticATokenBySender > 0 && toUnderlying => assetByRecipient_ > _assetByRecipient && assetByAToken_ < _assetByAToken;
	assert _staticATokenBySender > 0 && !toUnderlying => aTokenByRecipient_ > _aTokenByRecipient;
	assert _staticATokenBySender > 0 => aTokenByStaticAToken_ < _aTokenByStaticAToken && staticATokenBySender_ < _staticATokenBySender;
	assert assetByStaticAToken_ == _assetByStaticAToken;
	assert e.msg.sender != recipient => aTokenBySender_ == _aTokenBySender && assetBySender_ == _assetBySender && staticATokenByRecipient_ == _staticATokenByRecipient;
}


rule withdrawNoInterference(address recipient, address other, uint256 amount, bool toUnderlying, method f) filtered {
	f -> f.selector == withdraw(address, uint256, bool).selector ||
		f.selector == withdrawDynamicAmount(address, uint256, bool).selector
	}
{
	env e;
	setup(e, recipient);
	setup(e, other);
	require recipient != other;
	uint256 _assetByOther = ASSET.balanceOf(other);
	uint256 _staticATokenByOther = balanceOf(other);
	uint256 _aTokenByOther = ATOKEN.balanceOf(other);
	
	require amount > 0;
	if (f.selector == withdraw(address, uint256, bool).selector) {
		withdraw(e, recipient, amount, toUnderlying);
	}
	else {
		withdrawDynamicAmount(e, recipient, amount, toUnderlying);
	}
	uint256 assetByOther_ = ASSET.balanceOf(other);
	uint256 staticATokenByOther_ = balanceOf(other);
	uint256 aTokenByOther_ = ATOKEN.balanceOf(other);
	
	assert _assetByOther == assetByOther_;
	assert _staticATokenByOther == staticATokenByOther_;
	assert _aTokenByOther == aTokenByOther_;
}

rule permitIntegrity(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
{
	env e;
	uint256 nonceBefore = nonces(owner);
	permit(e, owner, spender, value, deadline, v, r, s);
	assert allowance(owner, spender) == value;
	assert nonces(owner) == nonceBefore + 1;
}

/*
rule claimRewardsIntegrity(address recipient) 
{
	env e;
	setup(e, recipient);	
	uint256 _rewardByStaticAToken = REWARD_TOKEN.balanceOf(currentContract);

	collectAndUpdateRewards(e);
	
	uint256 rewardByStaticAToken_ = REWARD_TOKEN.balanceOf(currentContract);
	assert INCENTIVES_CONTROLLER!=0, "missing 0 address check";
	assert rewardByStaticAToken_ >= _rewardByStaticAToken;
}
*/