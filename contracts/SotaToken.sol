pragma solidity ^0.4.24;


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
  uint256 constant _totalSupply = 10 * 1000 * 1000 * 1000;

  function totalSupply() public view returns (uint256)
  {
    return _totalSupply;
  }

  uint8 public decimals = 3;

  // Store these in fixed byte arrays to avoid analyzer warnings
  // TODO: is this compatible?

  bytes9 public name = "SOTAchain";
  bytes4 public symbol = "SOTA";

  address _ownerAddress;

  mapping(address => uint256) _balances;
  // INV_BAL: sum(values of `_balances`) = `_totalSupply`

  constructor() public {
    _ownerAddress = msg.sender;

    _balances[_ownerAddress] = _totalSupply;
  }

  function transfer(address _to, uint256 _value) public returns (bool)
  {
    require(_value <= _balances[msg.sender]); // A1

    // Overflow safe from A1
    _balances[msg.sender] = _balances[msg.sender] - _value;

    // Overflow safe from A1 & INV_BAL
    _balances[_to] = _balances[_to] + _value;
    
    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function balanceOf(address _holder) public view returns (uint256)
  {
    return _balances[_holder];
  }

  mapping (address => mapping (address => uint256)) internal _allowed;
  // INV_ALLOW: sum(values of `_allowed`) <= `_totalSupply`

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
  {
    require(_value <= _balances[_from]); // A1
    require(_value <= _allowed[_from][msg.sender]); // A2

    // Overflow safe from A1
    _balances[_from] = _balances[_from] - _value;

    // Overflow safe from (A1 | A2) & INV_ALLOW
    _balances[_to] = _balances[_to] + _value;

    // Overflow safe from A2
    _allowed[_from][msg.sender] = _allowed[_from][msg.sender] - _value;

    emit Transfer(_from, _to, _value);

    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool)
  {
    _allowed[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;
  }

  function allowance(address _holder, address _spender)
           public view returns (uint256)
  {
    return _allowed[_holder][_spender];
  }

  /*
   * TODO: implement dividends
   */
}
