// SPDX-License-Identifier: MIT
pragma solidity 0.5.0;

import "./ERC721Full.sol";

contract DigigrafNFT is ERC721Full {
  address payable public _contractOwner;
  uint public autographCount = 0;
  mapping(uint => Autograph) public autographs;

  struct Autograph {
    uint id;
    address payable creator;
    string uri;
    string price;
    address payable owner;
    bool isFirstSold;
    bool forSale;
    string requestId;
  }

  event AutographMint(address owner, string price, uint id, string uri);
  event AutographBought(address owner, string price, uint id, string uri);
  event SetAutographPrice(uint id, string price);

  constructor() ERC721Full("Digigraf", "DIGIGRAF") public {
  	_contractOwner = msg.sender;
  }

  function mint(string memory _tokenURI, string memory _price, string memory _requestId) public returns (bool) {

    // Make sure the tokenURI exists
    require(bytes(_tokenURI).length > 0);
    // Make sure the price exists
    require(bytes(_price).length > 0);
    // Make sure minter address exists
    require(msg.sender!=address(0));

    // uint _tokenId = totalSupply() + 1;
    autographCount ++;

    // _mint(msg.sender, _tokenId);    
    // _setTokenURI(_tokenId, _tokenURI);

    // Add Autograph to the contract
    autographs[autographCount] = Autograph(autographCount, msg.sender, _tokenURI, _price, msg.sender, false, false, _requestId);

    emit AutographMint(msg.sender, _price, autographCount, _tokenURI);

    uint _id = autographCount;

    //mint the initial nft to the owner who uploads it
    _mint(msg.sender, _id);

    return true;

  }  

  
  function buyFromOwner(uint _id) public payable {

    // Make sure the id is valid
    require(_exists(_id), "Error, wrong Token id");
    
    // Fetch the autograph
    Autograph memory _autograph = autographs[_id];    
    
    // Fetch the owner and new owner
    address payable _autographOwner= _autograph.owner;
    address payable _newowner= msg.sender;

    bool _isFirstSold = _autograph.isFirstSold;
    if (_isFirstSold == false) {
      _autograph.isFirstSold = true;
      
      uint fee1 = (msg.value * 4)/5;
      uint fee2 = msg.value/5;
      // Pay the owner 
      _autographOwner.transfer(fee2);
      // Pay the contract owner
      _contractOwner.transfer(fee1);
    } else {

      bool _forSale = _autograph.forSale;

      if (_forSale == true) {
        _autograph.forSale = false;
      } else {
        _autograph.forSale = true;
      }
      // Pay the owner by sending them Ether
      uint fee1 = (msg.value * 5) / 100;
      uint fee2 = msg.value/10;
      uint fee3 = (msg.value * 85)/100;
      // Pay the contract owner 
      _contractOwner.transfer(fee1);
      // Pay the creator
      _autograph.creator.transfer(fee2);
      // Pay the owner
      _autographOwner.transfer(fee3);
    }

    // Transfer the ERC721 ownership
    _transferFrom(_autographOwner, _newowner, _id);

    // Update the owner in struct
    _autograph.owner = _newowner;
    // Update the autograph
    autographs[_id] = _autograph;
    // Trigger an event
    emit AutographBought(_autograph.owner, _autograph.price, _autograph.id, _autograph.uri);
  }

  function setPrice(uint _id, string memory _price) public {
    // Make sure the id is valid
    require(_exists(_id), "Error, wrong Token id");
    // Make sure it costs more
    require(bytes(_price).length > 0, "Error, Token doesn't cost zero");
    // Make sure ownership
    require(msg.sender == autographs[_id].owner, "Only the owner of token can set price");    
    
    autographs[_id].price = _price;
    autographs[_id].forSale = true;

    emit SetAutographPrice(_id, _price);
  }

}