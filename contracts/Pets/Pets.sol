// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../utils/ERC721Preset.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./PetsProperties.sol";

contract Pets is ERC721Preset, ReentrancyGuard, PetsProperties {
    using Strings for uint256;

    // Pet mint price
    uint256 public petPrice;

    // Base pet types list
    string[] private basePetTypes = ["Panguin", "Turtle", "Dragon"];

    mapping(uint256 => uint256) public petBaseType;

    mapping(address => bool) public hasPet;

    // User pet id
    mapping(address => uint256) public userPet;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721Preset(name, symbol, baseTokenURI) {
        // petsPropertiesContract = _petsPropertiesContract;

        petPrice = 0.02 ether;
    }

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

    function getBaseType(uint256 tokenId)
        external
        view
        returns (string memory)
    {
        return basePetTypes[petBaseType[tokenId]];
    }

    function mintPet( uint256 baseType) public payable nonReentrant {
        require(userPet[msg.sender] == 0, "Only 1 pet");

        require(msg.value >= petPrice, "Insufficient value");

        _constructNewPet(currentTokenId(), baseType);

        // Record the pet id of this user
        userPet[msg.sender] = super.currentTokenId();

        super.mint(msg.sender);
    }


    function _constructNewPet(uint256 tokenId, uint256 baseType) internal {
        petBaseType[tokenId] = baseType;
        _initNewPet(tokenId);
    }

    function burn(uint256 tokenId) public override nonReentrant {
        require(userPet[msg.sender] > 0, "No pet");

        // Delete the record
        _clearPetProperty(tokenId);

        super.burn(tokenId);
    }
}
