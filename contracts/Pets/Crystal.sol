// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Crystal is ERC20, Ownable {
    constructor() ERC20("Crystal", "CYT") {}

    address public BlindBox;

    address public PetsProperties;

    function mint(address to, uint256 amount) external {
        require(_msgSender() == BlindBox, "Only blindbox");
        _mint(to, amount);
    }

    function burn() external {}
}
