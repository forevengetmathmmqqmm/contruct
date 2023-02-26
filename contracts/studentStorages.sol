// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
contract studentStorages {
    struct Student {
        uint id;
        string name;
        uint age;
    }

    Student[] public studentList;
    function setStudents(string memory _name, uint _age) public returns (uint) {
        uint index = studentList.length + 1;
        studentList.push(Student(index, _name, _age));
        return studentList.length;
    }
}