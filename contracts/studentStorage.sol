// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
contract studentStorage {
    uint public age;
    string public name;
    function setStudent(string memory _name, uint _age) public {
        age = _age;
        name = _name;
    }
    function getStudent() public view returns (string memory, uint) {
        return (name, age);
    }
}