// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import './interfaces/IERC165.sol';
contract ERC165 is IERC165 {
    constructor() {
        _registerInterface(calcFingerPrint());
    }
    function calcFingerPrint() public view returns (bytes4) {
        return bytes4(keccak256('supportsInterface(bytes4)'));
        //function supportsInterface value: 0x01ffc9a7
    }
    mapping(bytes4 => bool) private _supportedInterfaces;

    function supportsInterface(bytes4 interfaceId) external override view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    function _registerInterface(bytes4 interfaceId) public {
        require(interfaceId != 0xffffffff, 'ERC165: Invalid Interface');
        _supportedInterfaces[interfaceId] = true;
    }
}
