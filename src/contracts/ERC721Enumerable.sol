// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import "./interfaces/IERCEnumerable.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {
    uint256[] private _allTokens;
    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;
    //mapping from token ID index of te owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;
    //return total supply of the _allTokens array

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }
    function tokenByIndex(uint256 index) public override view returns (uint256) {
        require(index < totalSupply(), 'global index is out of bound');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public override view returns (uint256) {
        require(index < balanceOf(owner), 'owner index is out of bound');
        return _ownedTokens[owner][index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        //add token to the owner
        //add token to totalSupply
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokenToOwnerEnumeration(tokenId, to);
    }

    //add tokens to the _allTokens array and set the position of the tokens indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokenToOwnerEnumeration(uint256 tokenId, address to) private {
        //add address and tokenId to the _ownedTokens
        //_ownedTokensIndex tokenId set to the address of ownedTokens position
        //execute the function with minting
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function totalSupply() public override view returns (uint256) {
        return _allTokens.length;
    }
}
