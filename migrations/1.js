const Contracts = artifacts.require('studentStorage.sol');

module.exports = function (deployer) {
    deployer.deploy(Contracts);
} 