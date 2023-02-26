const Contracts = artifacts.require('studentStorages.sol');

module.exports = async function (callback) {
    console.log('qwqwqw');
    const contract = await Contracts.deployed();
    await contract.setStudents('lc', 21);
    console.log(await contract.studentList(0));
    callback();
}