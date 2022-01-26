// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ticket is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private tokenCount;
    Counters.Counter private physTokenCount;
    string private baseURI;
    uint256 public maxPhysAtt = 210;
    bool public paused = false;
    mapping(address => bool) public attendees;
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        _setBaseURI("");
    }

    function mint(
        address owner,
        string memory _tokenURI,
        bool isPhysical
    ) public onlyOwner returns (uint256) {
        require(!paused, "Ticket minting is paused at the moment");
        require(physTokenCount.current() < maxPhysAtt, "You can't mint beyound the max supply for physcical attendance");
        require(attendees[owner] != true, "User has already minted an NFT");

        tokenCount.increment();
        if (isPhysical) physTokenCount.increment();
        uint256 tokenId = tokenCount.current();

        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        attendees[owner] = true;

        return tokenId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function setMaxPhysAtt(uint256 _newMaxPhysAtt) public onlyOwner {
        maxPhysAtt = _newMaxPhysAtt;
    }

    function _setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function totalSupply() public view virtual returns (uint256) {
        return tokenCount.current();
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }
}
