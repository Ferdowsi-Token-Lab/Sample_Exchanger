// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract tokenB is ERC20 {

    constructor() ERC20("tokenB","BBB"){
        _mint(msg.sender,1000);
   }

}
