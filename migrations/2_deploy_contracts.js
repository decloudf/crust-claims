const CrustToken = artifacts.require("CrustToken");
const CrustClaims = artifacts.require("CrustClaims");

module.exports = async function(deployer, network) {
  const accounts = await web3.eth.getAccounts();
  const wallet = accounts[1]; //todo: use real account
  const reviewer = accounts[2];
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
