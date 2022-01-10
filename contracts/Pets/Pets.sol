// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../utils/ERC721Preset.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./PetsProperties.sol";

contract Pets is ERC721Preset, ReentrancyGuard, PetsProperties {
    using Strings for uint256;

    uint256 public petPrice;

    string[] private basePetTypes = ["Turtle", "Dragon"];

    mapping(uint256 => uint256) petBaseType;

    mapping(address => bool) public hasPet;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721Preset(name, symbol, baseTokenURI) {}

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(baseURI, petBaseType[tokenId].toString())
                )
                : "";
    }

    function mintPet(address to, uint256 baseType) public payable nonReentrant {
        require(!hasPet[_msgSender()], "Only 1 pet");
        require(msg.value >= petPrice, "Insufficient balance");

        _constructNewPet(currentTokenId(), baseType);

        super.mint(to);
    }

    function _constructNewPet(uint256 tokenId, uint256 baseType) internal {
        petBaseType[tokenId] = baseType;
    }

    function burn(uint256 tokenId) public override nonReentrant {
        require(hasPet[_msgSender()], "Do not have pet");
        _clearPetProperty(tokenId);
        super.burn(tokenId);
    }
}
