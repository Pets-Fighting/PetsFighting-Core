// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract BlindBox is ERC721Enumerable {
    uint256 public totalBoxes;

    constructor() ERC721("PetBlindBox", "PBB") {}

    function buy() external {
        _safeMint(msg.sender, totalBoxes);
        totalBoxes += 1;
    }
}
