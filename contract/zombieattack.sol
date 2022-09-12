// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    uint256 randNonce = 0;
    uint256 winRate = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce = randNonce.add(1);
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetZombieId)
        external
        onlyOwnerOf(_zombieId)
    {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage targetZombie = zombies[_targetZombieId];
        uint256 rand = randMod(100);

        if (rand <= winRate) {
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            targetZombie.loseCount = targetZombie.loseCount.add(1);
            feedAndMultiply(_zombieId, targetZombie.dna, "zombie");
        } else {
            myZombie.loseCount = myZombie.loseCount.add(1);
            targetZombie.winCount = targetZombie.winCount.add(1);
        }
        _triggerCooldown(myZombie);
    }
}
