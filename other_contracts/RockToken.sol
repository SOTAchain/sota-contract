pragma solidity ^0.4.18;

contract ERC20
{
    // Functions declaration
    function totalSupply() public constant returns (uint256 supply);
    function balanceOf(address who) public constant returns (uint value);
    function allowance(address owner, address spender) public constant returns (uint _allowance);
    function transfer(address to, uint value) public returns (bool ok);
    function transferFrom(address from, address to, uint value) public returns (bool ok);
    function approve(address spender, uint value) public returns (bool ok);
    
    // Events declaration
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract IceRockMining is ERC20
{
    uint256 _initialSupply = 10 * 1000 * 1000 * 1000; // Total Supply
    string public name = "ICE ROCK MINING";
    string public symbol = "ROCK2";
    uint8 public decimals = 3;
    
    mapping(address => uint) balances;
    mapping (address => mapping (address => uint256)) allowed;

    address _ownerAddress;
    
    event Burned(address indexed from, uint amount);
    event DividendsTransfered(address to, uint amount);
    
    function IceRockMining() public
    {
        _ownerAddress = msg.sender;
        
        // No crowdsale -- give all coins to the creator
        balances.insert(_ownerAddress, _initialSupply);
    }
    
    modifier onlyOwner
    {
        if (msg.sender == _ownerAddress) {
            _;
        }
    }
    
    function totalSupply() public constant returns (uint256)
    {
        return _initialSupply;
    }
    
    function balanceOf(address tokenHolder) public view returns (uint256 balance)
    {
        return balances.get(tokenHolder);
    }
    
    function allowance(address owner, address spender) public constant returns (uint256)
    {
        return allowed[owner][spender];
    }
    
    
    function transfer(address to, uint value) public returns (bool success)
    {
        if (balances.get(msg.sender) >= value && value > 0)
        {
            balances.insert(msg.sender, balances.get(msg.sender) - value);
    
            if (balances.contains(to)) {
                balances.insert(to, balances.get(to)+value);
            } else {
                balances.insert(to, value);
            }
    
            Transfer(msg.sender, to, value);
    
            return true;
    
        } else {
            return false;
        }
    }
    
    function transferFrom(address from, address to, uint256 value) public returns (bool success)
    {
        if (balances.get(from) >= value && allowed[from][msg.sender] >= value && value > 0)
        {
            uint amountToInsert = value;
    
            if (balances.contains(to))
            amountToInsert = amountToInsert+balances.get(to);
    
            balances.insert(to, amountToInsert);
            balances.insert(from, balances.get(from) - value);
            allowed[from][msg.sender] = allowed[from][msg.sender] - value;
            Transfer(from, to, value);
            return true;
        } else {
            return false;
        }
    }
    
    function approve(address spender, uint value) public returns (bool success) 
    {
        if ((value != 0) && (balances.get(msg.sender) >= value))
        {
            allowed[msg.sender][spender] = value;
            
            Approval(msg.sender, spender, value);
            
            return true;
        } else {
            return false;
        }
    }
    
    function setCurrentExchangeRate (uint rate) public onlyOwner
    {
        currentUSDExchangeRate = rate;
    }
    
    function setBonus (uint value) public onlyOwner
    {
        bonus = value;
    }
    
    function send(address addr, uint amount) public onlyOwner
    {
        sendp(addr, amount);
    }
    
    function sendp(address addr, uint amount) internal
    {
        require(addr != _ownerAddress);
        require(amount > 0);
        require (balances.get(_ownerAddress)>=amount);
    
    
        if (balances.contains(addr)) {
            balances.insert(addr, balances.get(addr)+amount);
        } else {
            balances.insert(addr, amount);
        }
    
        balances.insert(_ownerAddress, balances.get(_ownerAddress)-amount);
        Transfer(_ownerAddress, addr, amount);
    }
    
    function () public payable
    {
        uint amountInUSDollars = msg.value * currentUSDExchangeRate / 10**18;
        uint valueToPass = amountInUSDollars / priceUSD;
        valueToPass = (valueToPass * (100 + bonus))/100;
    
        if (balances.get(_ownerAddress) >= valueToPass)
        {
            if (balances.contains(msg.sender)) {
                balances.insert(msg.sender, balances.get(msg.sender)+valueToPass);
            } else {
                balances.insert(msg.sender, valueToPass);
            }
            
            balances.insert(_ownerAddress, balances.get(_ownerAddress)-valueToPass);
            Transfer(_ownerAddress, msg.sender, valueToPass);
        }
    }
    
    function approveDividends (uint totalDividendsAmount) public onlyOwner
    {
        uint256 dividendsPerToken = totalDividendsAmount*10**18 / _initialSupply;
        for (uint256 i = 0; i<balances.size(); i += 1) {
            address tokenHolder = balances.getKeyByIndex(i);
            
            if (balances.get(tokenHolder) > 0) {
                approvedDividends[tokenHolder] = balances.get(tokenHolder) * dividendsPerToken;
            }
        }
    }
    
    function burnUnsold() public onlyOwner returns (bool success)
    {
        uint burningAmount = balances.get(_ownerAddress);
        _initialSupply -= burningAmount;
        
        balances.insert(_ownerAddress, 0);
        Burned(_ownerAddress, burningAmount);
        
        return true;
    }
    
    // function approvedDividendsOf(address tokenHolder) public view returns (uint256) 
    // {
    //     return approvedDividends[tokenHolder];
    // }
    
    // function transferAllDividends() public onlyOwner
    // {
    //     for (uint256 i = 0; i< balances.size(); i += 1)
    //     {
    //         address tokenHolder = balances.getKeyByIndex(i);
            
    //         if (approvedDividends[tokenHolder] > 0)
    //         {
    //             tokenHolder.transfer(approvedDividends[tokenHolder]);
    //             DividendsTransfered (tokenHolder, approvedDividends[tokenHolder]);
    //             approvedDividends[tokenHolder] = 0;
    //         }
    //     }
    // }
    
    function withdraw(uint amount) public onlyOwner
    {
        _ownerAddress.transfer(amount);
    }
}
