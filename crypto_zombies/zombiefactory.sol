/**
    Wrong solidity version, but ok
 */
pragma solidity ^0.5.8;

contract ZombieFactory{
    // Uint is the same as unsigned integer 256
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // Events are a way for your contract to communicate that
    // something happened on the blockchain to your app
    // front-end, which can be 'listening' for certain events
    // and take action when they happen.
    // This particular event will fire when a new zombie is added.
    event NewZombie(uint zombieId, string name, uint dna);

    // Structs as normal languages
    // Data type with other data types
    struct Zombie {
        string name;
        uint dna;
    }

    // Arrays, declared as normal too
    Zombie[] public zombies;

    // Each account has an address -> Unique identifier
    // Mappings are another way of storing organized data in Solidity.
    // A mapping is essentially a key-value store for storing and looking up data.
    // In this case, we will use an uint to lookup for an address
    mapping (uint => address) public zombieToOwner;

    mapping (address => uint) ownerZombieCount;

    // Arguments should follow the convention with the underscore
    // before the argument name (_)
    // Also, when a function is private we should use (_)
    // before the name
    // By default we should make all functions private, and then
    // if needed public;
    function _createZombie(string _name, uint _dna) internal{
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // msg.sender => the address of the person who called the function
        // Giving the msg.sender address to the id of the Zombie
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] ++;
        emit NewZombie(id, _name, _dna);
    }

    // The view modifier means that the function will not use the values
    // and modify them. Only view, and return something.
    function _generateRandomDna(string _str) private view returns(uint){
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // require makes it so that the function will throw an error and
    // stop executing if some condition is not true
    // Normal use case of a function call
    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
