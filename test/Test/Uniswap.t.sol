// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// // Uniswap V3 interfaces
// interface ISwapRouter {
//     struct ExactInputSingleParams {
//         address tokenIn;
//         address tokenOut;
//         uint24 fee;
//         address recipient;
//         uint256 deadline;
//         uint256 amountIn;
//         uint256 amountOutMinimum;
//         uint160 sqrtPriceLimitX96;
//     }

//     function exactInputSingle(ExactInputSingleParams calldata params)
//         external
//         payable
//         returns (uint256 amountOut);
// }

// interface IERC20 {
//     function balanceOf(address account) external view returns (uint256);
//     function transfer(address to, uint256 amount) external returns (bool);
//     function approve(address spender, uint256 amount) external returns (bool);
//     function decimals() external view returns (uint8);
// }

// interface IWETH {
//     function deposit() external payable;
//     function withdraw(uint256 wad) external;
//     function balanceOf(address account) external view returns (uint256);
//     function approve(address spender, uint256 amount) external returns (bool);
// }

// contract UniswapSwapTest is Test {
//     // Mainnet addresses
//     address constant SWAP_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
//     address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // USDC mainnet address
    
//     // Pool fee (0.3%)
//     uint24 constant POOL_FEE = 3000;
    
//     ISwapRouter public swapRouter;
//     IWETH public weth;
//     IERC20 public usdc;
    
//     address public user;
//     uint256 public userPrivateKey;

//     function setUp() public {
//         // Fork mainnet - use a public RPC if env var not set
//         string memory rpcUrl;
//         try vm.envString("MAINNET_RPC_URL") returns (string memory url) {
//             rpcUrl = url;
//         } catch {
//             rpcUrl = "https://ethereum-rpc.publicnode.com";
//         }
        
//         uint256 forkId = vm.createFork(rpcUrl);
//         vm.selectFork(forkId);
        
//         // Verify we're on mainnet by checking block number
//         require(block.number > 18000000, "Fork failed - not on mainnet");
        
//         // Initialize contracts
//         swapRouter = ISwapRouter(SWAP_ROUTER);
//         weth = IWETH(WETH);
//         usdc = IERC20(USDC);
        
//         // Create test user
//         userPrivateKey = 0x1234;
//         user = vm.addr(userPrivateKey);
        
//         // Give user some ETH
//         vm.deal(user, 10 ether);
        
//         console.log("Setup complete:");
//         console.log("User address:", user);
//         console.log("User ETH balance:", address(user).balance / 1e18, "ETH");
//         console.log("Current block:", block.number);
//     }

//     function testSwapETHForUSDC() public {
//         uint256 amountIn = 1 ether; // 1 ETH
//         uint256 amountOutMinimum = 0; // Accept any amount of USDC out
        
//         vm.startPrank(user);
        
//         // Record initial balances
//         uint256 ethBalanceBefore = address(user).balance;
//         uint256 usdcBalanceBefore = usdc.balanceOf(user);
        
//         console.log("=== Before Swap ===");
//         console.log("ETH balance:", ethBalanceBefore / 1e18);
//         console.log("USDC balance:", usdcBalanceBefore / 1e6);
        
//         // Wrap ETH to WETH
//         weth.deposit{value: amountIn}();
//         console.log("Wrapped", amountIn / 1e18, "ETH to WETH");
        
//         // Approve the router to spend WETH
//         weth.approve(SWAP_ROUTER, amountIn);
        
//         // Set up swap parameters
//         ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
//             .ExactInputSingleParams({
//                 tokenIn: WETH,
//                 tokenOut: USDC,
//                 fee: POOL_FEE,
//                 recipient: user,
//                 deadline: block.timestamp + 300, // 5 minutes
//                 amountIn: amountIn,
//                 amountOutMinimum: amountOutMinimum,
//                 sqrtPriceLimitX96: 0 // No price limit
//             });
        
//         // Execute the swap
//         uint256 amountOut = swapRouter.exactInputSingle(params);
        
//         // Record final balances
//         uint256 ethBalanceAfter = address(user).balance;
//         uint256 usdcBalanceAfter = usdc.balanceOf(user);
        
//         console.log("=== After Swap ===");
//         console.log("ETH balance:", ethBalanceAfter / 1e18);
//         console.log("USDC balance:", usdcBalanceAfter / 1e6);
//         console.log("USDC received:", amountOut / 1e6);
        
//         // Assertions
//         assertEq(ethBalanceAfter, ethBalanceBefore - amountIn, "ETH balance should decrease by amountIn");
//         assertEq(usdcBalanceAfter, usdcBalanceBefore + amountOut, "USDC balance should increase by amountOut");
//         assertGt(amountOut, 0, "Should receive some USDC");
        
//         vm.stopPrank();
//     }

//     function testSwapUSDCForETH() public {
//         // First, get some USDC by swapping ETH
//         _getUSDC(user, 1000 * 1e6); // Get 1000 USDC
        
//         uint256 amountIn = 500 * 1e6; // 500 USDC
//         uint256 amountOutMinimum = 0; // Accept any amount of ETH out
        
//         vm.startPrank(user);
        
//         // Record initial balances
//         uint256 ethBalanceBefore = address(user).balance;
//         uint256 usdcBalanceBefore = usdc.balanceOf(user);
        
//         console.log("=== Before Swap ===");
//         console.log("ETH balance:", ethBalanceBefore / 1e18);
//         console.log("USDC balance:", usdcBalanceBefore / 1e6);
        
//         // Approve the router to spend USDC
//         usdc.approve(SWAP_ROUTER, amountIn);
        
//         // Set up swap parameters
//         ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
//             .ExactInputSingleParams({
//                 tokenIn: USDC,
//                 tokenOut: WETH,
//                 fee: POOL_FEE,
//                 recipient: user,
//                 deadline: block.timestamp + 300,
//                 amountIn: amountIn,
//                 amountOutMinimum: amountOutMinimum,
//                 sqrtPriceLimitX96: 0
//             });
        
//         // Execute the swap
//         uint256 amountOut = swapRouter.exactInputSingle(params);
        
//         // Unwrap WETH to ETH
//         weth.withdraw(amountOut);
        
//         // Record final balances
//         uint256 ethBalanceAfter = address(user).balance;
//         uint256 usdcBalanceAfter = usdc.balanceOf(user);
        
//         console.log("=== After Swap ===");
//         console.log("ETH balance:", ethBalanceAfter / 1e18);
//         console.log("USDC balance:", usdcBalanceAfter / 1e6);
//         console.log("ETH received:", amountOut / 1e18);
        
//         // Assertions
//         assertEq(usdcBalanceAfter, usdcBalanceBefore - amountIn, "USDC balance should decrease");
//         assertGt(ethBalanceAfter, ethBalanceBefore, "ETH balance should increase");
//         assertGt(amountOut, 0, "Should receive some ETH");
        
//         vm.stopPrank();
//     }

//     function testSwapWithAccountAbstraction() public {
//         // This shows how you might integrate with your AA wallet
//         uint256 amountIn = 0.5 ether;
        
//         vm.startPrank(user);
        
//         // Simulate your AA wallet calling the swap
//         // You would encode this as calldata for your AA wallet
//         bytes memory swapCalldata = abi.encodeCall(
//             ISwapRouter.exactInputSingle,
//             ISwapRouter.ExactInputSingleParams({
//                 tokenIn: WETH,
//                 tokenOut: USDC,
//                 fee: POOL_FEE,
//                 recipient: user, // or your AA wallet address
//                 deadline: block.timestamp + 300,
//                 amountIn: amountIn,
//                 amountOutMinimum: 0,
//                 sqrtPriceLimitX96: 0
//             })
//         );
        
//         // Wrap ETH first
//         weth.deposit{value: amountIn}();
//         weth.approve(SWAP_ROUTER, amountIn);
        
//         // Execute the call
//         (bool success, bytes memory result) = SWAP_ROUTER.call(swapCalldata);
//         require(success, "Swap failed");
        
//         uint256 amountOut = abi.decode(result, (uint256));
        
//         console.log("Swap executed via calldata");
//         console.log("Amount out:", amountOut / 1e6, "USDC");
        
//         assertGt(amountOut, 0, "Should receive USDC");
        
//         vm.stopPrank();
//     }

//     // Helper function to get USDC for testing
//     function _getUSDC(address to, uint256 amount) internal {
//         // Find a USDC whale (e.g., Binance hot wallet)
//         address usdcWhale = 0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503; // Binance 8
        
//         vm.startPrank(usdcWhale);
//         usdc.transfer(to, amount);
//         vm.stopPrank();
        
//         console.log("Transferred", amount / 1e6, "USDC to", to);
//     }

//     // Test helper to check current ETH/USDC price
//     function testGetCurrentPrice() public view {
//         // You can add price oracle integration here if needed
//         console.log("Current block:", block.number);
//         console.log("WETH address:", WETH);
//         console.log("USDC address:", USDC);
//     }

//     // Gas usage test
//     function testSwapGasUsage() public {
//         uint256 amountIn = 1 ether;
        
//         vm.startPrank(user);
        
//         weth.deposit{value: amountIn}();
//         weth.approve(SWAP_ROUTER, amountIn);
        
//         ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
//             .ExactInputSingleParams({
//                 tokenIn: WETH,
//                 tokenOut: USDC,
//                 fee: POOL_FEE,
//                 recipient: user,
//                 deadline: block.timestamp + 300,
//                 amountIn: amountIn,
//                 amountOutMinimum: 0,
//                 sqrtPriceLimitX96: 0
//             });
        
//         uint256 gasBefore = gasleft();
//         swapRouter.exactInputSingle(params);
//         uint256 gasUsed = gasBefore - gasleft();
        
//         console.log("Gas used for swap:", gasUsed);
        
//         vm.stopPrank();
//     }
// }