pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract SimpleStorage {
  struct Records {
  	uint recordCount;
  	string _firstName;
  	string _lastName;
  	string doctor;
  	string treatmentSite;
  	string date;
  	string ipfsHash;
  }

  mapping(address => Records[]) public users;
  mapping(address => string) public status;

  function set(address _address, string memory _doctor, string memory _site, string memory x, string memory _firstName, string memory _lastName, string memory _date) public{
  	require(msg.sender != _address);
    uint index = users[_address].length;
  	users[_address].push(Records(index, _firstName, _lastName, _doctor, _site, _date, x));
  }

  function setUser(address _address, string memory _status) public{
    require(msg.sender == _address);
    status[_address] = _status;
    //return users[_address].length;
  }
  function getUser(address _address) public view returns (string memory){
      return status[_address];
  }

  function getRecords(address _address) public view returns (Records[] memory){
      return users[_address];
  }

  function setPermission(uint i, address toAddress) public{
  	//users[toAddress].push(users[msg.sender][i]);
    require(msg.sender != toAddress);
    uint index = users[toAddress].length;
    Records memory parsedRecord = users[msg.sender][i];
    users[toAddress].push(Records(index, parsedRecord._firstName, parsedRecord._lastName, parsedRecord.doctor, parsedRecord.treatmentSite, parsedRecord.date, parsedRecord.ipfsHash));
  }

}