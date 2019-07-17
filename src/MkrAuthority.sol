/// MkrAuthority -- custom authority for MKR token access control

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

pragma solidity ^0.5.10;

contract MkrAuthority {
  address public root;
  modifier sudo { require(msg.sender == root); _; }
  function setRoot(address usr) public note sudo { root = usr; }

  mapping (address => uint) public wards;
  function rely(address usr) public note sudo { wards[usr] = 1; }
  function deny(address usr) public note sudo { wards[usr] = 0; }
  modifier auth { require(wards[msg.sender] == 1); _; }

  bytes4 constant mint = bytes4(keccak256(abi.encodePacked('mint(address,uint256)')));
  bytes4 constant burn = bytes4(keccak256(abi.encodePacked('burn(address,uint256)')));

  function canCall(address src, address dst, bytes4 sig)
      public view returns (bool)
  {
    if (sig == burn) {
      return true;
    } else if (sig == mint) {
      return (wards[src] == 1);
    } else {
      return false;
    }
  }
}