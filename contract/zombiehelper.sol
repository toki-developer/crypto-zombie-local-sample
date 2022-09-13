// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    using SafeMath for uint256;
    using SafeMath32 for uint32;

    uint256 levelUpFee = 0.001 ether;

    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function setLevelUpFee(uint256 _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint256 _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level = zombies[_zombieId].level.add(1);
    }

    function changeName(uint256 _zombieId, string memory _newName)
        external
        aboveLevel(2, _zombieId)
        onlyOwnerOf(_zombieId)
    {
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
        onlyOwnerOf(_zombieId)
    {
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter = counter.add(1);
            }
        }
        return result;
    }

    struct ZombieDetail {
        string name;
        uint256 dna;
        uint32 level;
        uint256 readyTime;
        uint16 winCount;
        uint16 loseCount;
        uint256 id;
    }

    function getZombiesDetailByOwner(address _owner)
        external
        view
        returns (ZombieDetail[] memory)
    {
        ZombieDetail[] memory result = new ZombieDetail[](
            ownerZombieCount[_owner]
        );
        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = ZombieDetail(
                    zombies[i].name,
                    zombies[i].dna,
                    zombies[i].level,
                    zombies[i].readyTime,
                    zombies[i].winCount,
                    zombies[i].loseCount,
                    i
                );
                counter = counter.add(1);
            }
        }
        return result;
    }
}
