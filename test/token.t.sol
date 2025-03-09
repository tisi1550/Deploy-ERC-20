// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Token.sol"; 

contract TokenTest is Test {
    Token token; // This should match the contract name in Token.sol

    address owner = address(0xaa);
    address recipient = address(0xbb);
    uint256 initialSupply = 1000 * 10**18;
    uint256 amount = 100 * 10**18;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        vm.prank(owner);
        token = new Token("Test Token", "TST", 18, initialSupply);
    }

    function testMetadata() public view {
        assertEq(token.name(), "Test Token");
        assertEq(token.symbol(), "TST");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), initialSupply);
    }

    function testTransfer() public {
        vm.prank(owner);
        token.transfer(recipient, amount);

        assertEq(token.balanceOf(recipient), amount);
        assertEq(token.balanceOf(owner), initialSupply - amount);
    }

    function testTransferInsufficientBalance() public {
        vm.prank(recipient);
        vm.expectRevert();
        token.transfer(owner, amount);
    }

    function testAllowance() public {
        vm.prank(owner);
        token.approve(recipient, amount);
        assertEq(token.allowance(owner, recipient), amount);

        vm.prank(recipient);
        token.transferFrom(owner, recipient, amount);
        assertEq(token.balanceOf(recipient), amount);
        assertEq(token.allowance(owner, recipient), 0);
    }

    function testMint() public {
        uint256 mintAmount = 500 * 10**18;
        vm.expectEmit(true, true, false, false);
        emit Transfer(address(0), recipient, mintAmount);
        token.mint(recipient, mintAmount);
        assertEq(token.balanceOf(recipient), mintAmount);
    }
}
