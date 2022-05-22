// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract tokenA is ERC20 {

    constructor(address a1, address a2) ERC20("tokenA","AAA"){
        _mint(msg.sender,1000);
        _mint(a1,100);
        _mint(a2,100);
    }

}