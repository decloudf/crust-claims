pragma solidity >=0.5.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

interface ICrustToken {
  function mint(address account, uint amount) external;
  function burn(address account, uint amount) external;
}

contract CrustToken is ERC20, ERC20Burnable, Ownable, ICrustToken {
  function name() public pure returns (string memory) {
    return "CRUST";
  }

  function symbol() public pure returns (string memory) {
    return "CRU";
  }

  function decimals() public pure returns (uint8) {
    return 18;
  }

  function burn(address account, uint amount) public onlyOwner {
    _burn(account, amount);
  }

  function mint(address account, uint amount) public onlyOwner {
    _mint(account, amount);
  }
}

contract CrustClaimsBase is Ownable {
  ICrustToken _token;
  address payable _wallet;
  uint _cap;
  uint _selled;

  event BuyCRU(address indexed _address, uint256 _value);
  event ClaimCRU(address indexed _address, uint256 _value, string crustAddr);
  event WithDraw(uint256 _value);

  constructor(
              address payable wallet,
              ICrustToken token,
              uint cap // cap: unit by eth
              ) public {
    _token = token;
    _wallet = wallet;
    _cap = cap * (10 ** 18);
    _selled = 0;
  }

  function buyCru() public payable {
    require(msg.value > 0, "should send some eth to buy cru token");
    uint selled = SafeMath.add(_selled, msg.value);
    require(selled <= _cap, "not enough token left");

    _selled = selled;
    _token.mint(msg.sender, msg.value);
    emit BuyCRU(msg.sender, msg.value);
    _wallet.transfer(msg.value);
  }

  //
  // claim token
  function claim(uint amount, string memory crustAddr) public {
    _token.burn(msg.sender, amount);
    emit ClaimCRU(msg.sender, amount, crustAddr);
  }

  //
  // should not be used, leave it here to cover some corner cases
  function withDraw(uint amount) public onlyOwner {
    _wallet.transfer(amount);
    emit WithDraw(amount);
  }
}

//
// locked tokens, disabled transfer functions
contract CrustTokenLocked is ICrustToken, Ownable {
  string _name;
  string _symbol;
  uint256 private _totalSupply;

  event Transfer(address indexed from, address indexed to, uint256 value);

  mapping (address => uint256) private _balances;

  constructor(string memory name, string memory symbol) public {
    _name = name;
    _symbol = symbol;
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public pure returns (uint8) {
    return 18;
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address account) public view returns (uint256) {
    return _balances[account];
  }

  function mint(address account, uint256 amount) public onlyOwner {
    require(account != address(0), "CrustToken: mint to the zero address");

    _totalSupply = SafeMath.add(_totalSupply, amount);
    _balances[account] = SafeMath.add(_balances[account], amount);
    emit Transfer(address(0), account, amount);
  }

  function burn(address account, uint256 amount) public onlyOwner{
    require(account != address(0), "CrustToken: burn from the zero address");

    _balances[account] = SafeMath.sub(_balances[account], amount, "CrustToken: burn amount exceeds balance");
    _totalSupply = SafeMath.sub(_totalSupply, amount);
    emit Transfer(account, address(0), amount);
  }
}

/* solium-disable-next-line */
contract CrustTokenLocked18 is CrustTokenLocked("CRUST18", "CRU18") {
}

/* solium-disable-next-line */
contract CrustTokenLocked24 is CrustTokenLocked("CRUST24", "CRU24") {
}

contract CrustClaims is CrustClaimsBase {
  constructor(
              address payable wallet,
              CrustToken token,
              uint cap // cap: unit by eth
              ) public CrustClaimsBase(wallet, token, cap) {
  }
}

contract CrustClaims18 is CrustClaimsBase {
  constructor(
              address payable wallet,
              CrustTokenLocked18 token,
              uint cap // cap: unit by eth
              ) public CrustClaimsBase(wallet, token, cap) {
  }
}

contract CrustClaims24 is CrustClaimsBase {
  constructor(
              address payable wallet,
              CrustTokenLocked24 token,
              uint cap
              ) public CrustClaimsBase(wallet, token, cap) {
  }
}
