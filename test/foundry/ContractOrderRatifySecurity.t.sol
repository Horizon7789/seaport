// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Adversarial harness for the generateOrder -> transfer -> ratifyOrder
/// boundary. The test is intentionally fail-closed: it only passes when the
/// malicious contract-offerer cannot cause Seaport to execute a transfer that
/// is inconsistent with the order subsequently ratified.
contract ContractOrderRatifySecurity {
    bool public generated;
    bool public ratified;
    bytes32 public generatedHash;

    function generateOrder(
        address,
        address,
        bytes32,
        uint256,
        bytes calldata
    ) external returns (bytes memory offer, bytes memory consideration) {
        generated = true;
        // The harness does not assert a vulnerability merely from arbitrary
        // generation. A real exploit must demonstrate an unauthorized asset
        // movement through the Seaport entry point.
        offer = new bytes(0);
        consideration = new bytes(0);
    }

    function ratifyOrder(
        bytes32 orderHash,
        bytes32[] calldata,
        bytes calldata,
        bytes32
    ) external returns (bytes4) {
        ratified = true;
        generatedHash = orderHash;
        return this.ratifyOrder.selector;
    }

    /// @dev This test intentionally fails until the repository contains a
    /// concrete integration PoC. It prevents CI from reporting a false green
    /// result merely because the harness compiled.
    function test_contractOrderRatifyPoC_isFailClosed() external pure {
        require(false, "POC_NOT_IMPLEMENTED: add concrete Seaport integration exploit or invariant proof");
    }
}
