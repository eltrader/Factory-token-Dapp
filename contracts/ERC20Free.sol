// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//
// Contract generated by MetaDapp (FCT)
// MetaDapp is just a Token platform creator
// MetaDapp is not the owner of this token
//
// MetaDapp Social:
// 📱 Telegram: https://t.me/metadapptg
// 🌎 Website: https://www.metadapp.dev
// 🌐 Youtube: https://www.youtube.com/channel/UCdRihNiJ0tJ7xpFGKcwZcdQ
//

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Free is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint256 supply,
        address owner
    ) ERC20 (name, symbol) {
        _mint(owner, supply * 10**18);
        transferOwnership(owner);
    }
}