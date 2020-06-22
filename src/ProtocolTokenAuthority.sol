/// ProtocolTokenAuthority -- custom authority for PROT token access control

// Copyright (C) 2019 Maker Ecosystem Growth Holdings, INC.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.6.7;

contract ProtocolTokenAuthority {
  address public root;
  modifier isRootCalling { require(msg.sender == root); _; }
  event LogSetRoot(address indexed newRoot);
  function setRoot(address usr) public isRootCalling {
    root = usr;
    emit LogSetRoot(usr);
  }

  mapping (address => uint) public authorizedAccounts;
  event LogRely(address indexed usr);
  function addAuthorization(address usr) public isRootCalling { authorizedAccounts[usr] = 1; emit LogRely(usr); }
  event LogDeny(address indexed usr);
  function removeAuthorization(address usr) public isRootCalling { authorizedAccounts[usr] = 0; emit LogDeny(usr); }

  constructor() public {
    root = msg.sender;
  }

  // bytes4(keccak256(abi.encodePacked('burn(uint256)')))
  bytes4 constant burn = bytes4(0x42966c68);
  // bytes4(keccak256(abi.encodePacked('burn(address,uint256)')))
  bytes4 constant burnFrom = bytes4(0x9dc29fac);
  // bytes4(keccak256(abi.encodePacked('mint(address,uint256)')))
  bytes4 constant mint = bytes4(0x40c10f19);

  function canCall(address src, address, bytes4 sig)
      public view returns (bool)
  {
    if (sig == burn || sig == burnFrom || src == root) {
      return true;
    } else if (sig == mint) {
      return (authorizedAccounts[src] == 1);
    } else {
      return false;
    }
  }
}
