const Contracts = artifacts.require('studentStorage.sol');

module.exports = async function (callback) {
    console.log('qwqwqw');
    const contract = await Contracts.deployed();
    console.log('contract', contract);
    await contract.setStudent('lc', 21);
    let data = await contract.getStudent();
    console.log(data);
    let name = await contract.name();
    let age = await contract.age();
    console.log(name, age);
    callback();
}