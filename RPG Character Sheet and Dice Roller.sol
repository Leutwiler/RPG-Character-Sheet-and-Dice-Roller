//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

contract RPG {

    enum Classes {
        Warrior,
        Assassin,
        Mage,
        Archer,
        Berserker,
        Priest,
        Necromancer,
        Summoner,
        Bard,
        Lancer
    }

    enum Races {
        Human,
        Dwarf,
        Gnome,
        Orc,
        Fairy,
        Centaur,
        Elf,
        Goblin
    }

    struct Character {
        string name;
        Classes class;
        Races race;
        uint8 level;
        uint16 winCount;
        uint16 lossCount;
        address owner;
    }

    Character[] public character;

    modifier onlyOwner(uint _characterId) {
        require(msg.sender == character[_characterId].owner, "Not owner");
        _;
    }    

    function createCharacter(string memory _name, Classes _class, Races _race) public {
        character.push(Character(_name, _class, _race, 1, 0, 0, msg.sender));
    }

    function levelUp(uint _characterId) public onlyOwner(_characterId) {
        character[_characterId].level++;
    }

    function levelDown(uint _characterId) public onlyOwner(_characterId) {
        character[_characterId].level--;
    }

    function rollDice(uint8 _numberOfDices, uint8 _numberOfFaces, uint8 _numberToWin, uint _characterId) public onlyOwner(_characterId) returns(uint, string memory message) {
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % (_numberOfDices * _numberOfFaces - _numberOfDices + 1);
        uint result = random + _numberOfDices;
        if (result >= _numberToWin) {
            message = "You won";
            character[_characterId].winCount++; 
        } else {
            message = "You lost";
            character[_characterId].lossCount++;
        }
        return (result, message);
    }    

}