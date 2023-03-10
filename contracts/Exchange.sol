// SPDX-License-Identifier: GPL-3.0
// 源码遵循协议， MIT...
pragma solidity >=0.4.16 <0.9.0; //限定solidity编译器版本
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol"; 
import "./KerwinToken.sol";
contract Exchange { 
    using SafeMath for uint256; //为了uint256后面使用 sub ,add方法，，

    //收费账户地址
    address public feeAccout ;
    uint256 public feePercent;//费率
    address constant ETHER = address(0);
    mapping(address=> mapping(address=>uint256)) public tokens;

    constructor(address _feeAccount,uint256 _feePercent){
        feeAccout = _feeAccount;
        feePercent = _feePercent;
    } 

    event Deposit(address token,address user,uint256 amount, uint256 balance);
    event WithDraw(address token,address user,uint256 amount, uint256 balance);
    //存以太币
    function depositEther() payable public{
        //msg.sender
        //msg.value
        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].add(msg.value);
        emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
    }
    //存其他货币
    function depositToken(address _token,uint256 _amount) public{
        require(_token!=ETHER);
        //调用某个方法强行从你账户往当前交易所账户转钱
        require(KerwinToken(_token).transferFrom(msg.sender,address(this),_amount));
        tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);

        emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    //提取以太币
    function withdrawEther(uint256 _amount) public{
        require(tokens[ETHER][msg.sender] >= _amount);
        tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].sub(_amount);
        //payable
        payable(msg.sender).transfer(_amount);
        emit WithDraw(ETHER,msg.sender,_amount ,tokens[ETHER][msg.sender]);
    }

    //提取KWT
    function withdrawToken(address _token,uint256 _amount) public{
        require(_token!=ETHER);
        require(tokens[_token][msg.sender] >= _amount);

        tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);

        //
        require(KerwinToken(_token).transfer(msg.sender, _amount));

        emit WithDraw(_token,msg.sender,_amount ,tokens[_token][msg.sender]);
    }
}