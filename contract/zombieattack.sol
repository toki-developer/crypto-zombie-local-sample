// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
    uint256 randNonce = 0;
    uint256 winRate = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetZombieId) external {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage targetZombie = zombies[_targetZombieId];
        uint256 rand = randMod(100);

        if (rand <= winRate) {
            myZombie.winCount++;
            myZombie.level++;
            targetZombie.loseCount++;
            feedAndMultiply(_zombieId, targetZombie.dna, "zombie");
        } else {
            myZombie.loseCount++;
            targetZombie.winCount++;
        }
        _triggerCooldown(myZombie);
    }
}
