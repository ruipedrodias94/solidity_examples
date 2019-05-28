/**
    Wrong solidity version, but ok
 */
pragma solidity ^0.5.8;

import "./zombiefactory.sol";

// In order to comunicate with other contracts on the Blockchain,
// we must implement interfaces. More like a skeleton of the function
// we want to interact with
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}
    
contract ZombieFeeding is ZombieFactory {
    
    // CryptoKitties address
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // In order to interact with other contracts, we must initiate them
    KittyInterface kittyContract = KittyInterface(ckAddress);

    // We must understand. Variables can have 2 properties.
    // Storage -> Permanent memory, stored on the Blockchain
    // Memory -> More like RAM. Just in memory during the execution

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        // Check if the zombie is ours.
        require(msg.sender == zombieToOwner[_zombieId]);
        // Store the zombie
        Zombie storage myZombie = zombies[_zombieId];
        // Assure that the targetDna doesn't exceeds 16 digits
        _targetDna = _targetDna % dnaModulus;

        uint newDna = (myZombie.dna + _targetDna) / 2;
        
        if (keccak256(abi.encodePacked("kitty")) == keccak256(abi.encodePacked(_species))) {
            newDna = newDna - newDna % 100 + 99;
        }

        // We also have other types of visibilities for functions,
        // Internal -> Same as private, but can be accessed by the heritage
        // External -> Same as public, but can only be accessed outside the contract
        _createZombie("NoName", newDna);
    }

    // In solidity we can return more than one value at a time,
    // but, when we don't want them all, we just do (,,a);
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
