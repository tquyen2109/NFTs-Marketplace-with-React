// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// Building minting function
// a. nft to point to an address
// b. keep track of the token ids
// c. keep track of token owner addresses to token ids
// d. keep track of how many tokens an owner address has
// e. create an event that emits a transfer log - contract address, where it being minted to, the id
contract ERC721 {
    //logging event
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    //Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;
    //Mapping from owner to number of owned token
    mapping(address => uint256) private _OwnedTokensCount;

    function _exists(uint256 tokenId) internal view returns (bool) {
        //setting the address nft owner to check the mapping of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        //return truthiness that address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal {
        //requires that the address is not zero
        require(to != address(0), 'ERC7621: minting to the zero address');
        //requires the token does not already exist
        require(!_exists(tokenId), 'ERC721 token already minted');
        //adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        //keeping track of each address that is minting and adding one to the count
        _OwnedTokensCount[to] = _OwnedTokensCount[to] + 1;
        emit Transfer(address(0), to, tokenId);
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), 'owner query for non-existing address');
        return _OwnedTokensCount[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), 'token does not exists');
        require(_tokenOwner[tokenId]!= address(0), 'owner query for non-existing address');
        return _tokenOwner[tokenId];
    }
}
