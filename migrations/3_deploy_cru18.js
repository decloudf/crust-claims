const CrustTokenLocked18 = artifacts.require("CrustTokenLocked18");
const CrustCrowdsale18 = artifacts.require("CrustCrowdsale18");

module.exports = async function(deployer) {
  const accounts = await web3.eth.getAccounts();
  const wallet = accounts[9]; //todo: use real account
  await deployer.deploy(CrustTokenLocked18);
  const crust18Instance = await CrustTokenLocked18.deployed();
  await deployer.deploy(CrustCrowdsale18, wallet, CrustTokenLocked18.address, 100);
  //
  // transfer ownership
  // make crowdsale contract own the token
  await crust18Instance.transferOwnership(CrustCrowdsale18.address);

  const crowdSale18Instance = await CrustCrowdsale18.deployed();
  //
  // transfer the ownership to the wallet address
  await crowdSale18Instance.transferOwnership(wallet);
};
