/**
    Wrong solidity version, but ok
 */
pragma solidity ^0.5.8;

contract ZombieFactory{
    // Uint is the same as unsigned integer 256
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // Structs as normal languages
    // Data type with other data types
    struct Zombie {
        string name;
        uint dna;
    }

    // Arrays, declared as normal too
    Zombie[] public zombies;

    // Arguments should follow the convention with the underscore
    // before the argument name (_)
    // Also, when a function is private we should use (_)
    // before the name
    // By default we should make all functions private, and then
    // if needed public;
    function _createZombie(string _name, uint _dna) private{
        zombies.push(Zombie(_name, _dna));
    }

    // The view modifier means that the function will not use the values
    // and modify them. Only view, and return something.
    function _generateRandomDna(string _str) private view returns(uint){
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // Normal use case of a function call
    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}