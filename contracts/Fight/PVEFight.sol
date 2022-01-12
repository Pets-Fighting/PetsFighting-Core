// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./FightBase.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PVEFight is FightBase {
    using Strings for uint256;

    constructor(address pets) FightBase(pets) {}

    // Type == 1: Train Fighting
    function trainFight() external {}
}
