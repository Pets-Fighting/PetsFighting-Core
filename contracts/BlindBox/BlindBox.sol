// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BlindBox is ERC721("PetBlindBox", "PBB") {
    uint256 public totalBoxes;

    function buy() external {
        _mint(msg.sender, totalBoxes);
        totalBoxes += 1;
    }

}
