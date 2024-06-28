// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.20;

import "./ERC20.sol";
import "./IERC20.sol";
import "./Ownable.sol";

contract IDOToken is ERC20("AXS Token", "AXS"), Ownable {
    // 定义公开的 IDO 价格，初始值为 0.1 ETH
    uint256 public idoPrice = 0.1 * 10**18;

    // 定义公开的最大购买量，初始值为 100 ETH
    uint256 public maxBuyAmount = 100 * 10**18;

    // 定义 USDT 代币的地址
    address public usdtAddress;

    // 定义一个映射，记录是否已经购买
    mapping(address => bool) private isBuy;

    function setUsdtAddress(address _usdtAddress) external {
        usdtAddress = _usdtAddress;
    }

    function buyToken(uint256 amount) public {
        require(amount < maxBuyAmount, "Invalid amount");
        require(isBuy[msg.sender] == false, "already bought");

        IERC20(usdtAddress).transferFrom(msg.sender, address(this), amount);

        // 计算购买数量
        uint256 mintAmt = (amount * 10**18) / idoPrice; // 先乘再除以避免精度问题

        // 标记用户已购买
        isBuy[msg.sender] = true;

        // 铸造新的代币给调用者
        mint(msg.sender, mintAmt);
    }

    function withdraw() public onlyOwner{
        uint256 balanceOf = balanceOf(address(this));
        ERC20(usdtAddress).transfer(msg.sender,balanceOf);
    }

}
