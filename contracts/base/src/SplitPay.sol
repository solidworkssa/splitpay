// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SplitPay {
    struct Payment {
        address payer;
        address[] recipients;
        uint256[] amounts;
        uint256 timestamp;
        bool distributed;
    }

    mapping(uint256 => Payment) public payments;
    uint256 public paymentCounter;

    event PaymentCreated(uint256 indexed paymentId, address payer);
    event PaymentDistributed(uint256 indexed paymentId);

    error InvalidInput();
    error TransferFailed();

    function createPayment(address[] memory recipients, uint256[] memory amounts) external payable returns (uint256) {
        if (recipients.length != amounts.length) revert InvalidInput();
        
        uint256 total = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            total += amounts[i];
        }
        if (total != msg.value) revert InvalidInput();

        uint256 paymentId = paymentCounter++;
        payments[paymentId] = Payment(msg.sender, recipients, amounts, block.timestamp, false);
        emit PaymentCreated(paymentId, msg.sender);

        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            if (!success) revert TransferFailed();
        }

        payments[paymentId].distributed = true;
        emit PaymentDistributed(paymentId);
        return paymentId;
    }

    function getPayment(uint256 paymentId) external view returns (Payment memory) {
        return payments[paymentId];
    }
}
