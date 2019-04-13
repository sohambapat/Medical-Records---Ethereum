pragma solidity ^0.4.24;

contract Medical{

	struct Persons{
		string _firstName;
		string _lastName;
		uint id;

	}
	struct Doctor{
		string _doctorName;
		string HospitalName;
	}

	 mapping(uint => Persons) public person;

	 unint public patientCount;


	 function addPatient (string _firstName, string _lastName ) private {
        patientCount ++;
        person[patientCount] = Persons(_firstName, _lastName, patientCount);
    }


    function addRecord(uint _id) public{
    	person[_id] = 
    }

	function viewRecord() public return(){

	}
	fuction
	
	function get() public view returns(string _) {
    	return value;
	}
}