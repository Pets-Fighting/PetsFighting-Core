// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


abstract contract Access {
    mapping(address => bool) isMinter;
}