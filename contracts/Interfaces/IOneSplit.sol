// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IOneSplit {
    function getExpectedReturn(
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 parts,
        uint256 disableFlags
    )
        external
        view
        returns (uint256 returnAmount, uint256[] memory distribution);

    function swap(
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] memory distribution,
        uint256 flags
    ) external payable returns (uint256 returnAmount);
}
