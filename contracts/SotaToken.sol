pragma solidity ^0.4.24;


library SafeMath {
  function sub(uint256 a, uint256 b) internal pure returns (uint256)
  {
    require(b <= a);

    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 c)
  {
    c = a + b;

    require(c >= a);

    return c;
  }
}


contract ERC20 {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SotaToken is ERC20 {
  uint256 _totalSupply = 10 * 1000 * 1000 * 1000;
  uint8 public decimals = 3;

  // Store these in fixed byte arrays to avoid analyzer warnings
  // TODO: is this compatible?

  bytes9 public name = "SOTAchain";
  bytes4 public symbol = "SOTA";

  address _ownerAddress;

  using SafeMath for uint256;

  mapping(address => uint256) balances;

  constructor() public {
    _ownerAddress = msg.sender;

    balances[_ownerAddress] = _totalSupply;
  }

  function totalSupply() public view returns (uint256)
  {
    return _totalSupply;
  }

  function transfer(address _to, uint256 _value) public returns (bool)
  {
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    
    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function balanceOf(address _owner) public view returns (uint256)
  {
    return balances[_owner];
  }

  mapping (address => mapping (address => uint256)) internal allowed;

  function transferFrom(address _from, address _to, uint256 _value)
           public returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);

    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool)
  {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);

    return true;
  }

  function allowance(address _owner, address _spender)
           public view returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /*
   * TODO: implement dividends
   */
}
