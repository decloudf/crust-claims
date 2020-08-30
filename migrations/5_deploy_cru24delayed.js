const CrustTokenLocked24Delayed = artifacts.require("CrustTokenLocked24Delayed");
const CrustClaims24Delayed = artifacts.require("CrustClaims24Delayed");
const { getDeployAccounts } = require('../config/accounts')

module.exports = async function(deployer, network) {
  const web3Accounts = await web3.eth.getAccounts()
  const accounts = await getDeployAccounts(network, web3Accounts)
  const wallet = accounts.owner;
  const reviewer = accounts.reviewer;
  await deployer.deploy(CrustTokenLocked24Delayed);
  const crust24DelayedInstance = await CrustTokenLocked24Delayed.deployed();
  await deployer.deploy(CrustClaims24Delayed, wallet, CrustTokenLocked24Delayed.address, 1000 * 10000);
  //
  // transfer ownership
  // make claims contract own the token
  await crust24DelayedInstance.transferOwnership(CrustClaims24Delayed.address);

  const claims24DelayedInstance = await CrustClaims24Delayed.deployed();
  //
  // transfer the ownership to the wallet address
  await claims24DelayedInstance.setReviewer(reviewer);
  await claims24DelayedInstance.transferOwnership(wallet);
};
