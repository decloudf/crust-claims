const CrustTokenLocked24Delayed = artifacts.require("CrustTokenLocked24Delayed");
const CrustClaims24Delayed = artifacts.require("CrustClaims24Delayed");

module.exports = async function(deployer) {
  const accounts = await web3.eth.getAccounts();
  const wallet = accounts[1]; //todo: use real account
  const reviewer = accounts[2]; //todo: use real account
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
