pragma solidity ^0.4.24;

import "./SotaToken.sol";

contract SotaTokenMock is SotaToken {

  constructor(address ownerAddress) public {
    _ownerAddress = ownerAddress;

    balances[_ownerAddress] = _totalSupply;
  }

}
