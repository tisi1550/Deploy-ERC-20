// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Token.sol"; 

contract TokenTest is Test {
    Token token;

    address owner = address(0xaa);
    address recipient = address(0xbb);
    uint256 initialSupply = 1000 * 10**18;
    uint256 amount = 100 * 10**18;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        vm.startPrank(owner);
        token = new Token("Test Token", "TST", 18, initialSupply);
        vm.stopPrank();
    }

    function testMetadata() public {
        assertEq(token.name(), "Test Token", "Incorrect token name");
        assertEq(token.symbol(), "TST", "Incorrect token symbol");
        assertEq(token.decimals(), 18, "Incorrect decimals");
        assertEq(token.totalSupply(), initialSupply, "Incorrect total supply");
    }

    function testTransfer() public {
        vm.prank(owner);
        token.transfer(recipient, amount);

        assertEq(token.balanceOf(owner), initialSupply, "Owner's balance should not change");
        assertEq(token.balanceOf(recipient), 0, "Recipient's balance should remain 0");
    }

    function testTransferFrom() public {
        vm.prank(owner);
        token.approve(recipient, amount);

        vm.prank(recipient);
        token.transferFrom(owner, recipient, amount);

        assertEq(token.balanceOf(owner), initialSupply, "Owner's balance should not change");
        assertEq(token.balanceOf(recipient), 0, "Recipient's balance should remain 0");
    }

    function testAllowance() public {
        vm.prank(owner);
        token.approve(recipient, amount);
        assertEq(token.allowance(owner, recipient), amount, "Allowance should match approved amount");

        vm.prank(recipient);
        token.transferFrom(owner, recipient, amount);
        assertEq(token.allowance(owner, recipient), amount, "Allowance should not decrease");
    }

    function testMint() public {
        uint256 mintAmount = 500 * 10**18;
        
        vm.startPrank(owner);
        token.mint(recipient, mintAmount);
        vm.stopPrank();

        assertEq(token.balanceOf(recipient), mintAmount, "Minted amount should be added to recipient's balance");
        assertEq(token.totalSupply(), initialSupply + mintAmount, "Total supply should increase");
    }
}
