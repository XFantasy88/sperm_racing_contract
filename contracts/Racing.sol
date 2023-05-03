// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Racing is Ownable {
    struct Bet {
        address bettor;
        bool rewarded;
        uint256 spermNo;
        uint256 amount;
    }

    address public feeWallet;
    uint256 public feeAmount;

    uint256 public spermsCount;

    uint256 private totalBets;

    mapping(uint256 => Bet) bets;

    constructor() Ownable() {
        spermsCount = 5;
    }

    function createBet(uint256 spermNo) external payable {}

    function setFeeWallet(address wallet) external onlyOwner {
        feeWallet = wallet;
    }

    function setFeeAmount(uint256 amount) external onlyOwner {
        feeAmount = amount;
    }

    function setSpermsCount(uint256 count) external onlyOwner {
        spermsCount = count;
    }
}
