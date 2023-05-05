// SPDX-License-Identifier: GPL-3.0
// 源码遵循协议， MIT...
pragma solidity >=0.4.16 <0.9.0; //限定solidity编译器版本
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol"; 
import "./LCToken.sol";
contract Exchange { 
    using SafeMath for uint256; //为了uint256后面使用 sub ,add方法，，

    //收费账户地址
    address public feeAccout ;
    uint256 public feePercent;//费率
    address constant ETHER = address(0);
    mapping(address=> mapping(address=>uint256)) public tokens;
    // 币a交换币b
    struct _Order {
        uint256 id;
        address user;
        address tokenA;
        uint256 aCount;
        address TokenB;
        uint256 bCount;
        uint256 timestamp;
    }
    mapping(uint256 => _Order) public orderList;
    uint256 public order_id;
    constructor(address _feeAccount,uint256 _feePercent){
        feeAccout = _feeAccount;
        feePercent = _feePercent;
    } 
    event Order(uint256 id,address user,address tokenA,uint256 aCount,address TokenB,uint256 bCount,uint256 timestamp);
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
    // 查询余额
    function balanceOf(address _token, address _user ) public view returns (uint256 count) {
        return tokens[_token][_user];
    }
    // 创建订单
    function createOrder(address tokenA, uint256 countA, address tokenB, uint256 countB) public returns(uint256 orderId){
        require(balanceOf(tokenA, msg.sender) >= countA, unicode'余额不足');
        order_id = order_id.add(1);
        orderList[order_id] = _Order(order_id, msg.sender, tokenA, countA, tokenB, countB, block.timestamp);
        event Order(order_id, msg.sender, tokenA, countA, tokenB, countB, block.timestamp)
    }
}