// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library PetUtils {
    function randInt(uint256 _length, uint256 _seed)
        internal
        view
        returns (uint256)
    {
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(block.difficulty, block.timestamp, _seed)
            )
        );
        return random % _length;
    }


    function safeSub(uint256 value1, uint256 value2)
        internal
        pure
        returns (uint256)
    {
        if (value1 > value2) {
            return (value1 - value2);
        }
        return 0;
    }
}
