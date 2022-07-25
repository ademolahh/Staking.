// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

error NotAllowed();
error MaxSupplyReached();

contract Token is ERC20 {
    uint256 public constant MAX_SUPPLY = 1000000 * 10**18;
    mapping(address => bool) private allowedAddress;

    constructor() ERC20("My Token", "MTK") {
        _mint(msg.sender, MAX_SUPPLY);
    }
}
