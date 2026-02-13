// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/SplitPay.sol";

contract SplitPayTest is Test {
    SplitPay public c;
    
    function setUp() public {
        c = new SplitPay();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
