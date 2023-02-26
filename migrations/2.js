const Contracts = artifacts.require('studentStorages.sol');
module.exports = function (deployer) {
    deployer.deploy(Contracts);
} 