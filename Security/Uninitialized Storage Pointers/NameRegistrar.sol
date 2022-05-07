
contract NameRegistrar {

    bool public unlocked = false;

    struct NameRecord {
        bytes32 name;
        address mappedAddress;
    }

    mapping(address => NameRecord) public registeredNameRecords;
    mapping(bytes32 => address) public resolve;

    function register(bytes32 _name, address _mappedAddress) public {

        // uninitialized, hence defaults to a storage variable
        NameRecord newRecord;

        // updates slot[0], pointed by unlock
        newRecord.name = _name;

        // updates slot[1], pointed by registeredNameRecords
        newRecord.mappedAddress = _mappedAddress;

        resolve[_name] = _mappedAddress;

        registeredNameRecords[msg.sender] = newRecord;

        // even if unlocked was false in the beginning of the execution,
        // if _name has a nonzero last byte, then slot[0]'s last byte will be nonzero
        // hence unlocked, boolean pointer to the slot[0], will be true,
        // execution completes without reverting 
        require(unlocked);
    }

    // storage and memory specifiers should be used for the complex types

}
