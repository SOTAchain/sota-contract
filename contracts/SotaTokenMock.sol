
import "./SotaToken.sol";

contract SotaTokenMock is SotaToken {

  constructor(address ownerAddress) public {
    _ownerAddress = ownerAddress;

    balances[_ownerAddress] = _totalSupply;
  }

}
