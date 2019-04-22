pragma solidity ^0.5.0;

contract SimpleStorage {
  string ipfsHash;
  string firstName;
  string lastName;
  string date;

 
  struct Records {
  	uint recordCount;
  	string _firstName;
  	string _lastName;
  	string doctor;
  	string treatmentSite;
  	string date;
  	string ipfsHash;
  }

  mapping(address => Records[]) public people;

  function set(address _address, string memory _doctor, string memory _site, string memory x, string memory _firstName, string memory _lastName, string memory _date) public{
  	uint index = people[_address].length;
  	people[_address].push(Records(index, _firstName, _lastName, _doctor, _site, _date, x));
  }

  function setPermission(uint i, address toAddress) public{
  	people[toAddress].push(people[msg.sender][i]);
  }

}

