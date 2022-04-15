// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "lib/ds-test/src/test.sol";
import "src/RPGCharacter.sol";
import "testdata/cheats/Cheats.sol";

contract RPGTest is DSTest, Details {
    RPG public rpg;
    Cheats public cheats = Cheats(HEVM_ADDRESS);

    function setUp() public {
        rpg = new RPG();
    }

function testLevel(uint _characterId) public {
        cheats.assume(_characterId <= 1);
        rpg.createCharacter("Andrey", Classes.Archer, Races.Dwarf);
        rpg.createCharacter("Gomes", Classes.Bard, Races.Human);
        assertEq(rpg.getLevel(_characterId), 1);
        rpg.levelUp(_characterId);
        assertEq(rpg.getLevel(_characterId), 2);
        rpg.levelDown(_characterId);
        assertEq(rpg.getLevel(_characterId), 1);
    }

    function testRollDice(uint8 _numberOfDice, uint8 _numberOfFaces) public {
        cheats.assume(_numberOfFaces >= 1 && _numberOfDice >= 1 && uint(_numberOfDice) * uint(_numberOfFaces) <= 255);
        require(_numberOfFaces >= 1 && _numberOfDice >= 1 && uint(_numberOfDice) * uint(_numberOfFaces) <= 255);
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % (_numberOfDice * _numberOfFaces - _numberOfDice + 1);
        uint result = random + _numberOfDice;
        assertGe(result,_numberOfDice);
        assertLe(result,_numberOfDice*_numberOfFaces);
    }
}