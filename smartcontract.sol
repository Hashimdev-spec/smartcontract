pragma solidity ^0.6.0;

contract AccessControlledStorage {
    uint public storedData;
    address public owner;
    mapping(address => bool) public admins;

    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event DataStored(uint data);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }
    
    modifier onlyAdmin() {
        require(admins[msg.sender], "Only an admin can perform this action.");
        _;
    }

    constructor() public {
        owner = msg.sender; // Set the contract creator as the owner
        admins[msg.sender] = true; // The owner is also an admin
    }

    // Add a new admin
    function addAdmin(address _admin) public onlyOwner {
        require(!admins[_admin], "Address is already an admin.");
        admins[_admin] = true;
        emit AdminAdded(_admin);
    }
    
    // Remove an existing admin
    function removeAdmin(address _admin) public onlyOwner {
        require(admins[_admin], "Address is not an admin.");
        admins[_admin] = false;
        emit AdminRemoved(_admin);
    }

    // Set a new value, only callable by admins
    function set(uint _data) public onlyAdmin {
        require(_data < 1000, "Value can not be over 1000");
        storedData = _data;
        emit DataStored(_data);
    }

    // Get the stored value, callable by anyone
    function get() public view returns (uint _retVal) {
        return storedData;
    }
}
