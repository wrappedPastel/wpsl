// contracts/wPSL.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "zeppelin/contracts/token/ERC20/ERC20.sol";
import "zeppelin/contracts/access/Ownable.sol";

contract WPSL is ERC20, Ownable {

  struct PSL {
    uint    blockNum;
    address sender;
    string  pslAddress;
    uint256 amount;
  }

  mapping (address => mapping (string => PSL)) public PastelTransfers;

  uint256 public sentToPSL;

  event TransferToPSL(
    uint indexed    blockNum,
    address indexed sender,
    string          psladdress, 
    uint256         amount);

  constructor(uint256 initialSupply) ERC20("Wrapped PSL", "WPSL") {
    sentToPSL = 0;
    _mint(msg.sender, initialSupply);
  }

  function transferToPSL(string calldata psladdress, uint256 amount) external returns (bool) {
    
    _burn(msg.sender, amount);

    PastelTransfers[msg.sender][psladdress] = PSL(block.number, msg.sender, psladdress, amount);

    sentToPSL += amount;

    emit TransferToPSL(block.number, msg.sender, psladdress, amount);

    return true;
  }


  function decimals() public view virtual override returns (uint8) {
    return 5;
  }
  
  function reSupply(uint256 addSupply) public onlyOwner returns (uint256) {
    _mint(msg.sender, addSupply);
    return totalSupply();
  }
}
