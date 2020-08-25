const CrustTokenLocked24 = artifacts.require("CrustTokenLocked24");
const CrustCrowdsale24 = artifacts.require("CrustCrowdsale24");

module.exports = async function(deployer) {
  const accounts = await web3.eth.getAccounts();
  const wallet = accounts[9]; //todo: use real account
  await deployer.deploy(CrustTokenLocked24);
  const crust24Instance = await CrustTokenLocked24.deployed();
  await deployer.deploy(CrustCrowdsale24, wallet, CrustTokenLocked24.address, 100);
  //
  // transfer ownership
  // make crowdsale contract own the token
  await crust24Instance.transferOwnership(CrustCrowdsale24.address);

  const crowdSale24Instance = await CrustCrowdsale24.deployed();
  //
  // transfer the ownership to the wallet address
  await crowdSale24Instance.transferOwnership(wallet);
};
