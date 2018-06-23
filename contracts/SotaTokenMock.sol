pragma solidity ^0.4.24;

import "./SotaToken.sol";

contract SotaTokenMock is SotaToken {

  constructor(address ownerAddress, uint256 totalSupply) public {
    _ownerAddress = ownerAddress;
    _totalSupply = totalSupply;

    _balances[_ownerAddress] = _totalSupply;
  }

}
