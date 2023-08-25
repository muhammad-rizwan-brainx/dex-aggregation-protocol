//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Interfaces/IQuickSwap.sol";
import "./Interfaces/IUniSwap.sol";
import "./Interfaces/IPancakeSwap.sol";
import "./Interfaces/IOneSplit.sol";

contract AggregationProtocol {
    IQuickSwapRouter public quickSwapRouter;
    IPancakeSwapRouter public pancakeSwapRouter;
    IUniswapV2Router01 public sushiswapRouter;
    IUniswapV2Router01 public uniswapRouter;
    IOneSplit public oneSplit;

    constructor(
        address _uniSwapRouter,
        address _sushiSwapRouter,
        address _oneSplit,
        address _quickSwapRouter,
        address _pancakeSwapRouter
    ) {
        uniswapRouter = IUniswapV2Router01(_uniSwapRouter);
        sushiswapRouter = IUniswapV2Router01(_sushiSwapRouter);
        quickSwapRouter = IQuickSwapRouter(_quickSwapRouter);
        pancakeSwapRouter = IPancakeSwapRouter(_pancakeSwapRouter);
        oneSplit = IOneSplit(_oneSplit);
    }

    function getPrice(
        address tokenA,
        address tokenB,
        uint256 amount
    ) public view returns (uint256 retAmount, string memory exchange) {
        uint256 uPrice = getTokenPriceFromUniswap(tokenA, tokenB, amount);
        uint256 sPrice = getTokenPriceFromSushiswap(tokenA, tokenB, amount);
        uint256 onePrice = getTokenPriceFromOneSplit(tokenA, tokenB, amount);
        uint256 qPrice = getTokenPriceFromOneSplit(tokenA, tokenB, amount);
        uint256 pPrice = getTokenPriceFromOneSplit(tokenA, tokenB, amount);

        if (
            uPrice > sPrice &&
            uPrice > onePrice &&
            uPrice > qPrice &&
            uPrice > pPrice
        ) {
            retAmount = uPrice;
            exchange = "uniswap";
        } else if (
            sPrice > uPrice &&
            sPrice > onePrice &&
            sPrice > qPrice &&
            sPrice > pPrice
        ) {
            retAmount = sPrice;
            exchange = "sushiswap";
        } else if (
            onePrice > sPrice &&
            onePrice > uPrice &&
            onePrice > qPrice &&
            onePrice > pPrice
        ) {
            retAmount = onePrice;
            exchange = "oneinch";
        } else if (
            qPrice > sPrice &&
            qPrice > onePrice &&
            qPrice > uPrice &&
            qPrice > pPrice
        ) {
            retAmount = onePrice;
            exchange = "oneinch";
        } else if (
            pPrice > sPrice &&
            pPrice > onePrice &&
            pPrice > qPrice &&
            pPrice > uPrice
        ) {
            retAmount = pPrice;
            exchange = "oneinch";
        } else {
            retAmount = uPrice;
            exchange = "uniswap";
        }
    }

    function buyWithQuickSwap(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) public returns (uint256[] memory) {
        uint256[] memory amounts = quickSwapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
        return amounts;
    }

    function buyWithPancakeSwap(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) public returns (uint256[] memory) {
        uint256[] memory amounts = pancakeSwapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
        return amounts;
    }

    function buyWithUniswap(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) public returns (uint256[] memory) {
        uint256[] memory amounts = uniswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
        return amounts;
    }

    function buyWithSushiSwap(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) public returns (uint256[] memory) {
        uint256[] memory amounts = sushiswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
        return amounts;
    }

    function getTokenPriceFromUniswap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn
    ) public view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        uint256[] memory amountsOut = uniswapRouter.getAmountsOut(
            amountIn,
            path
        );

        return amountsOut[1];
    }

    function getTokenPriceFromSushiswap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn
    ) public view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        uint256[] memory amountsOut = sushiswapRouter.getAmountsOut(
            amountIn,
            path
        );

        return amountsOut[1];
    }

    function getTokenPriceFromOneSplit(
        address tokenIn,
        address tokenOut,
        uint256 amountIn
    ) public view returns (uint256) {
        (, uint256[] memory amountsOut) = oneSplit.getExpectedReturn(
            tokenIn,
            tokenOut,
            amountIn,
            1,
            0
        );

        return amountsOut[1];
    }

    function getTokenPriceFromQuickSwap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn
    ) public view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        uint256[] memory amountsOut = quickSwapRouter.getAmountsOut(
            amountIn,
            path
        );

        return amountsOut[1];
    }

    function getTokenPriceFromPancakeSwap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn
    ) public view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        uint256[] memory amountsOut = pancakeSwapRouter.getAmountsOut(
            amountIn,
            path
        );

        return amountsOut[1];
    }
}
