// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Racing is Ownable {
    using SafeERC20 for IERC20;

    struct Bet {
        address bettor;
        bool rewarded;
        uint256 spermNo;
        uint256 amount;
        uint256 winnerSperm;
    }

    uint256 public spermsCount;

    uint256 private totalBets;

    mapping(uint256 => Bet) bets;

    constructor() Ownable() {
        spermsCount = 5;
    }

    function createBet(uint256 spermNo) external payable {
        require(spermNo < spermsCount, "Invalid sperm number");
        uint256 amount = msg.value;

        require(amount > 0, "Insufficient balance");

        uint256 random = uint256(
            keccak256(
                abi.encode(
                    block.timestamp,
                    blockhash(block.number - 1),
                    spermsCount,
                    spermNo,
                    amount,
                    msg.sender,
                    block.chainid
                )
            )
        ) % spermsCount;

        Bet memory newBet = Bet(msg.sender, false, spermNo, amount, random);

        uint256 betId = totalBets;

        totalBets += 1;
        bets[betId] = newBet;
    }

    function claimReward(uint256 betId) external {
        require(totalBets > betId, "Invalid bet id");

        Bet memory bet = bets[betId];
        require(bet.bettor == msg.sender, "Not bettor");
        require(!bet.rewarded, "Already rewarded");

        require(bet.winnerSperm == bet.spermNo, "Not winner");

        uint256 amount = bet.amount * 2;

        _transferEth(msg.sender, amount);
    }

    function withdraw(address token, uint256 amount) external onlyOwner {
        if (token == address(0)) {
            _transferEth(owner(), amount);
        } else {
            _transferToken(token, address(this), owner(), amount);
        }
    }

    function setSpermsCount(uint256 count) external onlyOwner {
        spermsCount = count;
    }

    function getActiveBets() external view returns (Bet[] memory) {
        uint256 activeCounts = 0;

        for (uint i = 0; i < totalBets; i++) {
            if (bets[i].bettor == msg.sender && !bets[i].rewarded) {
                activeCounts++;
            }
        }

        Bet[] memory activeBets = new Bet[](activeCounts);

        uint256 activeId = 0;
        for (uint i = 0; i < totalBets; i++) {
            if (bets[i].bettor == msg.sender && !bets[i].rewarded) {
                activeBets[activeId] = bets[i];
                activeId += 1;
            }
        }

        return activeBets;
    }

    function _transferToken(
        address token,
        address from,
        address to,
        uint256 amount
    ) internal {
        require(
            IERC20(token).balanceOf(from) >= amount,
            "Insufficient balance"
        );

        if (from == address(this)) {
            IERC20(token).safeTransfer(to, amount);
        } else {
            IERC20(token).safeTransferFrom(from, to, amount);
        }
    }

    function _transferEth(address to, uint256 amount) internal {
        require(address(this).balance >= amount, "Insufficient balance");

        (bool success, ) = to.call{value: amount}("");

        require(success, "Failed to transfer eth");
    }
}
