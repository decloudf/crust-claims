const CrustCoin = artifacts.require("CrustCoin");
const CrustCrowdsale = artifacts.require("CrustCrowdsale");

module.exports = async function(deployer) {
  const accounts = await web3.eth.getAccounts();
  const wallet = accounts[9]; //todo: use real account
  await deployer.deploy(CrustCoin);
  const crustInstance = await CrustCoin.deployed();
  await deployer.deploy(CrustCrowdsale, wallet, CrustCoin.address, 100);
  //
  // transfer ownership
  // make crowdsale contract own the token
  await crustInstance.transferOwnership(CrustCrowdsale.address);

  const crowdSaleInstance = await CrustCrowdsale.deployed();
  //
  // transfer the ownership to the wallet address
  await crowdSaleInstance.transferOwnership(wallet);
};
