# RPG Character Sheet and Dice Roller

In this repository you can find a RPG Character Sheet where you can create a character and input his/her name, race, class and level. You can also roll a dice and select its inputs, such as number of dice, number of faces of each dice and minimum number to win.

Your character will also be attatched to a win and loss count, which is based on your dice results.

The main goal of this project is to provide a tool in the blockchain for casual RPG players to store their characters and also roll dice. So it's a complementary application for your RPG match and not a full game replacement.

This is my first Solidity project :)

## Base of our code 👨‍💻

The following code represents the base of all the project. We're creating an enum for specifying both the class and race of the character, because it's better to have a limited list of them, not allowing the player to use a random string for these inputs.

We're also defining the struct of the character, which has a name, class, race, level, win and loss count and the address of the owner. An array was created in order to players be able to create loads and loads of characters.

In the end of the base code, a modifier was created to attatch the created character to its respective owner.

```
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
```

## Functions for our character 🏃‍♂️

The functions of the code to change our character are:
* createCharacter: to create a new character using the name, class and race provided by the player
* levelUp: you can level up your character anytime you want as this code is just a complementary tool for your match that will work as your character sheet
* levelDown: you can also level down in case of a levelUp miss click or even if your character gets a level debuff during the game

```
    function createCharacter(string memory _name, Classes _class, Races _race) public {
        character.push(Character(_name, _class, _race, 1, 0, 0, msg.sender));
    }

    function levelUp(uint _characterId) public onlyOwner(_characterId) {
        character[_characterId].level++;
    }

    function levelDown(uint _characterId) public onlyOwner(_characterId) {
        character[_characterId].level--;
    }
```

## Dice roller 🎲

This function refers to our dice roller. The inputs are:
* _numberOfDice: select how many dice you want to roll
* _numberOfFaces: select how many faces your dice have
* _numberToWin: select the minimum number that makes you win (usually suggested by the game master)
* _characterId: select the id of your character in order to play and make the win/loss count goes up

The uint random line may seem confusing, but it's actually very important to understand. As we're rolling a dice, we must stipulate both the floor and ceiling value, because if we are playing with three dice of six faces, then the minimum number is 3 and the maximum number is 18 as there is not a dice with a value lower than one and greater than six. The ceiling value is easy to set, but what about the floor value? Solidity always starts on zero, so if we want the minimum value to be 3 in this example (because we have three dice), it's easier to tell Solidity to generate a random number between 0 and 15 (the original 18 subtracted by the number of dice) in order to get what we want. Later on, we just need to increment the number of dice value to get the right result.

The function will return your dice number and a message saying if you won or not.

```
    function rollDice(uint8 _numberOfDice, uint8 _numberOfFaces, uint8 _numberToWin, uint _characterId) public onlyOwner(_characterId) returns(uint, string memory message) {
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % (_numberOfDice * _numberOfFaces - _numberOfDice + 1);
        uint result = random + _numberOfDice;
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
```

## Thanks 😄
Thanks for reading my code! This one was very special because it was my first Solidity project! I'm also happy for being able to develop a random number generator that has a flexible floor and ceiling value according to the choosen parameters.

If you would like to talk to me, feel free to text me on Twitter or LinkedIn.
