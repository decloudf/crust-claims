pragma solidity >=0.5.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

interface ICrustToken {
 function mint(address account, uint amount) external;
 function burn(address account, uint amount) external;
}

contract CrustCoin is ERC20, ERC20Burnable, Ownable, ICrustToken {
    constructor() public {
    }

		function name() public pure returns (string memory) {
        return "crust";
    }

	 function symbol() public pure returns (string memory) {
        return "cru";
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

contract CrustCrowdsaleBase is Ownable {
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
    ) public
    {
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

	 function mint(address account, uint256 amount) public onlyOwner {
      require(account != address(0), "CrustToken: mint to the zero address");

      _totalSupply = SafeMath.add(_totalSupply, amount);
      _balances[account] = SafeMath.add(_balances[account], amount);
      emit Transfer(address(0), account, amount);
  }

	function totalSupply() public view returns (uint256) {
     return _totalSupply;
  }

  function balanceOf(address account) public view returns (uint256) {
      return _balances[account];
  }

	function burn(address account, uint256 amount) public onlyOwner{
     require(account != address(0), "CrustToken: burn from the zero address");

     _balances[account] = SafeMath.sub(_balances[account], amount, "CrustToken: burn amount exceeds balance");
     _totalSupply = SafeMath.sub(_totalSupply, amount);
     emit Transfer(account, address(0), amount);
  }
}

contract CrustTokenLocked18 is CrustTokenLocked("crust18", "cru18") {
}

contract CrustTokenLocked24 is CrustTokenLocked("crust24", "cru24") {
}

contract CrustCrowdsale is CrustCrowdsaleBase {
	constructor(
     address payable wallet,
     CrustCoin token,
		 uint cap // cap: unit by eth
   ) public CrustCrowdsaleBase(wallet, token, cap) {
  }
}

contract CrustCrowdsale18 is CrustCrowdsaleBase {
	constructor(
     address payable wallet,
     CrustTokenLocked18 token,
		 uint cap // cap: unit by eth
   ) public CrustCrowdsaleBase(wallet, token, cap) {
  }
}

contract CrustCrowdsale24 is CrustCrowdsaleBase {
  constructor(
     address payable wallet,
     CrustTokenLocked24 token,
		uint cap
   ) public CrustCrowdsaleBase(wallet, token, cap) {
  }
}

// contract CrustCoin16 {
// 	event BuyCRU(address indexed _address, uint256 _value);
// 	event ClaimCRU(address indexed _address, uint256 _value);
// 	event WithDraw(uint256 _value);
// 
// 	constructor() public {
// 		balances[tx.origin] = 10000;
// 		owner = msg.sender;
// 	}
// 
// 	function buyCru() public payable returns (bool success) {
// 		require(msg.value > 0, "should send some eth to buy cru");
// 		balances[msg.sender] += msg.value;
// 		emit BuyCRU(msg.sender, msg.value);
// 		return true;
// 	}
// 
//   //
// 	// claim token
// 	function claim(uint amount) public returns (bool claimed) {
// 		require(balances[msg.sender] >= amount, "insuffient balance");
// 		balances[msg.sender] -= amount;
// 		emit ClaimCRU(msg.sender, amount);
// 		return true;
// 	}
// 
// 	function withDraw(uint amount) public returns (bool success) {
// 		require(msg.sender == owner, "only owner can withraw!");
// 		address payable receiveAddr = address(uint160(owner));
// 		receiveAddr.transfer(amount);
//     emit WithDraw(amount);
// 		return true;
// 	}
// }