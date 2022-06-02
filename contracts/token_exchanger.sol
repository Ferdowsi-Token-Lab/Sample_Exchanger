// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract token_exchanger {
    event proposed(
        uint256 indexed id,
        address indexed asset1,
        uint256 amount1,
        address indexed asset2,
        uint256 amount2
    );
    event canceled(uint256 indexed id);
    event accepted(uint256 indexed id);

    enum states {
        pending,
        canceled,
        accepted
    }

    struct deal {
        uint256 id;
        address asset1;
        address account1;
        uint256 amount1;
        address asset2;
        address account2;
        uint256 amount2;
        states state;
    }

    deal[] deals;

    function propose(
        address asset1,
        uint256 amount1,
        address asset2,
        uint256 amount2
    ) public returns (uint256) {
        require(amount1 > 0 && amount2 > 0);
        require(IERC20(asset1).allowance(msg.sender, address(this)) >= amount1);

        deal memory d;
        d.id = deals.length;
        d.asset1 = asset1;
        d.account1 = msg.sender;
        d.amount1 = amount1;
        d.asset2 = asset2;
        d.amount2 = amount2;
        d.state = states.pending;

        deals.push(d);

        emit proposed(d.id, asset1, amount1, asset2, amount2);
        return d.id;
    }

    function accept(uint256 id) public {
        require(id < deals.length);
        deal memory d = deals[id];
        require(d.state == states.pending);
        require(
            IERC20(d.asset1).allowance(d.account1, address(this)) >= d.amount1
        );
        require(
            IERC20(d.asset2).allowance(msg.sender, address(this)) >= d.amount2
        );
        require(IERC20(d.asset1).balanceOf(d.account1) >= d.amount1);
        require(IERC20(d.asset2).balanceOf(msg.sender) >= d.amount2);

        bool b1 = IERC20(d.asset1).transferFrom(
            d.account1,
            msg.sender,
            d.amount1
        );
        if (b1) {
            bool b2 = IERC20(d.asset2).transferFrom(
                d.account2,
                d.account1,
                d.amount2
            );
            if (b2) {
                deals[id].account2 = msg.sender;
                deals[id].state = states.accepted;
                emit accepted(id);
            } else revert();
        } else revert();
    }

    function cancel(uint256 id) public {
        require(id < deals.length);
        deal memory d = deals[id];
        require(d.state == states.pending);
        require(d.account1 == msg.sender);

        deals[id].state = states.canceled;

        emit canceled(id);
    }

    function getStatus(uint256 _id) external view returns (string memory) {
        string memory result = "ERR";
        if (_id < deals.length) {
            if (deals[_id].state == states.pending) result = "pending";
            else if (deals[_id].state == states.accepted) result = "accepted";
            else if (deals[_id].state == states.canceled) result = "canceled";
        }
        return result;
    }
}
