const CrustTokenLocked24 = artifacts.require("CrustTokenLocked24");
const CrustClaims24 = artifacts.require("CrustClaims24");

module.exports = async function(deployer) {
  const accounts = await web3.eth.getAccounts();
  const wallet = accounts[1]; //todo: use real account
  const reviewer = accounts[2]; //todo: use real account
  await deployer.deploy(CrustTokenLocked24);
  const crust24Instance = await CrustTokenLocked24.deployed();
  await deployer.deploy(CrustClaims24, wallet, CrustTokenLocked24.address, 1000 * 10000);
  //
  // transfer ownership
  // make claims contract own the token
  await crust24Instance.transferOwnership(CrustClaims24.address);

  const claims24Instance = await CrustClaims24.deployed();
  //
  // transfer the ownership to the wallet address
  await claims24Instance.setReviewer(reviewer);
  await claims24Instance.transferOwnership(wallet);
};
