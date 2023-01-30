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
    //Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    function _exists(uint256 tokenId) internal view returns (bool) {
        //setting the address nft owner to check the mapping of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        //return truthiness that address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
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

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(to != address(0), 'ERC721: Error - Transfer to the zero address');
        require(ownerOf(tokenId) == from, 'Trying to transfer a token the address does not own');
        //update token owner mapping
        _tokenOwner[tokenId] = to;
        //update from address token balance
        _OwnedTokensCount[from] = _OwnedTokensCount[from] - 1;
        //update to address token balance
        _OwnedTokensCount[to] = _OwnedTokensCount[to] + 1;
        emit Transfer(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        _transferFrom(from, to, tokenId);
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), 'owner query for non-existing address');
        return _OwnedTokensCount[owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), 'token does not exists');
        require(_tokenOwner[tokenId] != address(0), 'owner query for non-existing address');
        return _tokenOwner[tokenId];
    }

}
