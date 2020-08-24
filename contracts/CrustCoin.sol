pragma solidity >=0.5.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract CrustCoin is ERC20, ERC20Burnable, Ownable {
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

contract CrustCrowdsale {
	CrustCoin _token;
	address payable _wallet;
	address payable _owner;
	uint _cap;
	uint _selled;

 	event BuyCRU(address indexed _address, uint256 _value);
 	event ClaimCRU(address indexed _address, uint256 _value, string crustAddr);
 	event WithDraw(uint256 _value);

    constructor(
        address payable wallet,
        CrustCoin token,
				uint cap // cap: unit by eth
    ) public
    {
			_token = token;
			_wallet = wallet;
			_owner = msg.sender;
			_cap = cap * (10 ** 18);
			_selled = 0;
    }

 	function buyCru() public payable {
 		require(msg.value > 0, "should send some eth to buy cru");
		uint selled = SafeMath.add(_selled, msg.value);
		require(selled <= _cap, "not enough cru left");

		_selled = selled;
		_token.mint(msg.sender, msg.value);
 		emit BuyCRU(msg.sender, msg.value);
		_wallet.transfer(msg.value);
 	}
 
   //
 	// claim token
 	function claim(uint amount, string crustAddr) public {
		_token.burn(msg.sender, amount);
 		emit ClaimCRU(msg.sender, amount, crustAddr);
 	}
 
 	function withDraw(uint amount) public {
 		require(msg.sender == _owner, "only owner can withraw!");
 		_owner.transfer(amount);
    emit WithDraw(amount);
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