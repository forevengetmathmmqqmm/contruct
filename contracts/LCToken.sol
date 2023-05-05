// SPDX-License-Identifier: GPL-3.0
// 源码遵循协议， MIT...
pragma solidity >=0.4.16 <0.9.0; //限定solidity编译器版本
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol"; 

contract LCToken {
  using SafeMath for uint256; //为了uint256后面使用 sub ,add方法，，
  string public name = 'LCToken';
  string public symbol = 'LC';
  uint256 public decimals = 18;
  uint256 public totalSupply;
  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;
  constructor(){
    totalSupply = 1000000 * (10 ** decimals);
    //部署账号
    balanceOf[msg.sender] = totalSupply;
  }
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(_to != address(0));
    _transfer(msg.sender, to, val);
    return true;
  }

  function _transfer(address from, address to, uint256 val) internal {
    require(balanceOf[from] >=val);
    balanceOf[from] = balanceOf[from].sub(val);
    balanceOf[to] = balanceOf[to].add(val);

    emit Transfer(from, to, val);
  }
  // 授权给交易所
  function approve(address _spender, uint256 _value) public returns (bool success){
    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender,_spender,_value);
    return true;
  }
  //被授权得交易所调用
  function transferFrom(address _from, address _to, uint256 _val) {
    require(balanceOf[_from] >= _val);
    require(allowance[_from][msg.sender] >= _val);
    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_val);
    _transfer(_from, _to, _val);
    return true;
  }
}