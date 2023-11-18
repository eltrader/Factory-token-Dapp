const FCTToken = artifacts.require('FCTToken')

module.exports = (deployer) => {
    deployer.deploy(FCTToken)
}