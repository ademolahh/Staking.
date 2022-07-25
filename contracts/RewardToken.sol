// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

error NotAllowed();
error MaxSupplyReached();

contract RewardToken is ERC20 {
    uint256 public constant MAX_SUPPLY = 1000000 * 10**18;
    mapping(address => bool) private allowedAddress;

    constructor() ERC20("My Token", "MTK") {}

    function mint(address addr, uint256 amount) public {
        if (amount + totalSupply() >= MAX_SUPPLY) revert MaxSupplyReached();
        if (!allowedAddress[msg.sender]) revert NotAllowed();
        _mint(addr, amount);
        console.log("Total supply:", totalSupply());
    }

    function setControlAddress(address addr, bool state) public {
        allowedAddress[addr] = state;
    }
}
