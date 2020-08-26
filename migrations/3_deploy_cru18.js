const CrustTokenLocked18 = artifacts.require("CrustTokenLocked18");
const CrustClaims18 = artifacts.require("CrustClaims18");

module.exports = async function(deployer) {
  const accounts = await web3.eth.getAccounts();
  const wallet = accounts[9]; //todo: use real account
  await deployer.deploy(CrustTokenLocked18);
  const crust18Instance = await CrustTokenLocked18.deployed();
  await deployer.deploy(CrustClaims18, wallet, CrustTokenLocked18.address, 100);
  //
  // transfer ownership
  // make claims contract own the token
  await crust18Instance.transferOwnership(CrustClaims18.address);

  const claims18Instance = await CrustClaims18.deployed();
  //
  // transfer the ownership to the wallet address
  await claims18Instance.transferOwnership(wallet);
};
