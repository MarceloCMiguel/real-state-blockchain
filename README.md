# Real Estate Blockchain Project

This project implements a basic smart contract on the Ethereum blockchain to simulate an Initial Public Offering (IPO) and subsequent trading of shares representing ownership in a real estate asset. The project utilizes Vyper, a programming language for writing smart contracts on Ethereum.

## Overview

The smart contract facilitates the initial sale of shares (tokens) representing ownership in a real estate asset during an IPO. After the IPO phase, users can buy, sell, and withdraw dividends based on their share ownership. Dividends are generated from the rental income of the real estate asset.

## Features

- **IPO Phase**: The contract initiates with an IPO phase where shares are sold to investors.
- **Buying Shares**: Users can buy shares during the IPO phase and afterward.
- **Selling Shares**: Shareholders can sell their shares to other users.
- **Dividend Distribution**: Dividends are distributed to shareholders based on their share ownership.
- **Owner's Privileges**: The owner of the contract can deposit dividends and close the contract after the IPO phase.

## Smart Contract Functions

1. **Initialization (`__init__`)**:
   - Initializes the contract with the price per share and the total number of shares available for sale during the IPO phase.

2. **Buying Shares (`buy`)**:
   - Allows users to buy shares by sending Ether to the contract. Checks are performed to ensure sufficient shares are available and the sent Ether covers the cost.

3. **Deposit Dividends (`deposity_div`)**:
   - Allows the contract owner to deposit dividends into the contract.

4. **Withdraw Dividends (`sacar`)**:
   - Allows shareholders to withdraw their dividends.

5. **Selling Shares (`sell`)**:
   - Allows shareholders to sell their shares to other users for Ether.

6. **Close IPO Phase (`opa`)**:
   - Closes the IPO phase and ends further share issuance. The remaining balance in the contract is sent to the owner.

## How to Use

1. **Deploy Contract**:
   - Deploy the smart contract to the Ethereum blockchain, specifying the price per share and the total number of shares available for sale during the IPO phase.

2. **Buy Shares**:
   - During the IPO phase or afterward, users can buy shares by sending Ether to the contract.

3. **Sell Shares**:
   - Shareholders can sell their shares to other users by calling the `sell` function.

4. **Withdraw Dividends**:
   - Shareholders can withdraw their dividends by calling the `sacar` function.

5. **Close Contract**:
   - After the IPO phase, the contract owner can close the contract by calling the `opa` function, ending further share issuance and withdrawing the remaining balance.

## Security Considerations

- **Assertions**: The contract uses assertions to ensure that certain conditions are met before executing functions, enhancing security by preventing unintended behavior.

## Future Improvements

- **Enhanced Security**: Implement additional security measures, such as access control and input validation, to further secure the contract.
- **User Interface**: Develop a user interface (UI) to interact with the contract, making it more user-friendly.
- **Gas Optimization**: Optimize contract functions to reduce gas costs and improve efficiency.

## Disclaimer

This project is for educational and demonstration purposes only. It may contain bugs or vulnerabilities, and its use in a production environment is not recommended without thorough testing and auditing by security professionals. The creators of this project are not liable for any damages or losses resulting from the use of this code.
