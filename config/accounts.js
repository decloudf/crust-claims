const { deployAccounts } = require('./deploy_data')
/***
    const mnemonic = 'memo words'
    const infuraKey = 'api key'

    const deployAccounts = {
    ropsten: {
      owner: 'owner address',
      reviewer: 'reviewer address',
    }
    }

    module.exports = {
    deployAccounts,
    mnemonic,
    infuraKey,
    }
    **/

function getDeployAccounts(network, web3Accounts) {
  console.log('network: ', network)
  if (deployAccounts[network]) {
    return deployAccounts[network]
  }
  return {
    owner: web3Accounts[1],
    reviewer: web3Accounts[2],
  }
}

module.exports = {
  getDeployAccounts: getDeployAccounts,
}
