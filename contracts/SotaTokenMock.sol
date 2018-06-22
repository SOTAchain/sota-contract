
import "./SotaToken.sol";

contract SotaTokenMock is SotaToken {

  constructor(address initialAccount, uint256 initialBalance) public {
    balances[initialAccount] = initialBalance;
    _totalSupply = initialBalance;
  }

}
