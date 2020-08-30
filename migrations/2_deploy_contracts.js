const CrustToken = artifacts.require("CrustToken");
const CrustClaims = artifacts.require("CrustClaims");
const { getDeployAccounts } = require('../config/accounts')

module.exports = async function(deployer, network) {
  const web3Accounts = await web3.eth.getAccounts()
  const accounts = await getDeployAccounts(network, web3Accounts)
  console.log('using accounts: %j', accounts)
  const wallet = accounts.owner;
  const reviewer = accounts.reviewer;
  await deployer.deploy(CrustToken);
  const crustInstance = await CrustToken.deployed();
  await deployer.deploy(CrustClaims, wallet, CrustToken.address, 1000 * 10000);
  //
  // transfer ownership
  // make claims contract own the token
  await crustInstance.transferOwnership(CrustClaims.address);

  const claimsInstance = await CrustClaims.deployed();
  //
  // transfer the ownership to the wallet address
  await claimsInstance.setReviewer(reviewer);
  await claimsInstance.transferOwnership(wallet);
};
