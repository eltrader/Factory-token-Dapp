const FCTTokenFactory = artifacts.require('FCTTokenFactory')

module.exports = (deployer) => {
    deployer.deploy(FCTTokenFactory, 'CONTRATO DE TOKEN CAMBIAR')
}