// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SplitPay Contract
/// @author solidworkssa
/// @notice Automated payment splitting contract.
contract SplitPay {
    string public constant VERSION = "1.0.0";


    function split(address[] memory _recipients) external payable {
        require(_recipients.length > 0, "No recipients");
        uint256 amount = msg.value / _recipients.length;
        for (uint256 i = 0; i < _recipients.length; i++) {
            payable(_recipients[i]).transfer(amount);
        }
    }

}
