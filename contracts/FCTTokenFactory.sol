// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// Tokens types
// 1 = Standard, 2 = Burnable, 3 = Mintable
import "./ERC20Free.sol";
import "./ERC20Standard.sol";
import "./ERC20Burnable.sol";
import "./ERC20Mintable.sol";

contract FCTTokenFactory is Ownable {
    using Address for address;
    using SafeMath for uint256;
    using SafeMath for uint8;
    using SafeMath for uint;

    IERC20Metadata private fct;
    uint256 private deployPriceBNB = 100000000000000000; // 0.1 BNB
    uint256 private deployPriceFCT = 556799999999999930000; // 557 FCT (-20%) => 0.08 BNB

    constructor(address _fct){
        fct = IERC20Metadata(_fct);
    }

    function deployFree(
        string memory name,
        string memory symbol,
        uint256 supply
    ) external returns(address){
        return address(new ERC20Free(
            name,
            symbol,
            supply,
            _msgSender()
        ));
    }

    function _deploy(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 supply,
        uint tokenType
    ) private returns(address){
        if(tokenType == 1)
            return address(
                new ERC20Standard(name, symbol, decimals, supply, _msgSender()));

        if(tokenType == 2)
            return address(
                new ERC20Burnable(name, symbol, decimals, supply, _msgSender()));

        if(tokenType == 3)
            return address(
                new ERC20Mintable(name, symbol, decimals, supply, _msgSender()));

        return address(0);
    }

    function deployPaidBNB(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 supply,
        uint tokenType
    ) external payable returns(address){
        require(msg.value == deployPriceBNB);

        return _deploy(name, symbol, decimals, supply, tokenType);
    }

    function deployPaidFCT(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 supply,
        uint tokenType
    ) external returns(address){
        require(fct.balanceOf(_msgSender()) >= deployPriceFCT);
        require(fct.allowance(_msgSender(), address(this)) >= deployPriceFCT);
        require(fct.transferFrom(_msgSender(), address(this), deployPriceFCT));

        return _deploy(name, symbol, decimals, supply, tokenType);
    }

    function getDeployPriceFCT() external view returns(uint256){
        return deployPriceFCT;
    }

    function getDeployPriceBNB() external view returns(uint256){
        return deployPriceBNB;
    }

    function getPaidTokenAddress() external view returns(address){
        return address(fct);
    }

    function getPaidTokenDecimals() external view returns(uint8){
        return fct.decimals();
    }

    function updateDeployPriceFCT(uint256 newPrice) external onlyOwner {
        deployPriceFCT = newPrice;
    }

    function updateDeployPriceBNB(uint256 newPrice) external onlyOwner {
        deployPriceBNB = newPrice;
    }

    function withdrawBNB(address payable account) external onlyOwner {
        (bool success, ) = account.call{value: address(this).balance}("");
        require(success);
    }

    function withdrawToken(address account, uint256 amount) external onlyOwner {
        require(fct.transfer(account, amount));
    }

    function withdrawTokenAll(address account) external onlyOwner {
        require(fct.transfer(account, fct.balanceOf(address(this))));
    }

    receive() external payable {}
    fallback() external payable {}
}