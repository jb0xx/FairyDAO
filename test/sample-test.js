const { expect } = require("chai");
const { ethers } = require("hardhat");

// describe("Greeter", function () {
//   it("Should return the new greeting once it's changed", async function () {
//     const Greeter = await ethers.getContractFactory("Greeter");
//     const greeter = await Greeter.deploy("Hello, world!");
//     await greeter.deployed();

//     expect(await greeter.greet()).to.equal("Hello, world!");

//     const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

//     // wait until the transaction is mined
//     await setGreetingTx.wait();

//     expect(await greeter.greet()).to.equal("Hola, mundo!");
//   });
// });

describe("FuzzyMath", function () {
  it("Should get us fractional exponent within bound", async function () {
    const FuzzyMath = await ethers.getContractFactory("FuzzyMath");
    const fuzzyMath = await FuzzyMath.deploy();
    await fuzzyMath.deployed();

    // square roots with fibonacci sequence
    let square;
    for (let i = 1; i < 10 ** 4; i += i) {
      square = i ** 2;
      expect(await fuzzyMath.fraxExp(square, 1, 2)).to.equal(i);
    }

    // cubic roots with fibonacci sequence
    let cube;
    for (let i = 1; i < 10 ** 4; i += i) {
      cube = i ** 3;
      expect(await fuzzyMath.fraxExp(cube, 1, 3)).to.equal(i);
    }

    // test all valid single-digit pairs of a and b on i^b for i [2,9]
    let temp;
    for (let a = 1; a < 6; a++) {
      for (let b = 2; b < 6; b++) {
        for (let i = 1; i < 10; i += 1) {
          temp = i ** b;
          expect(await fuzzyMath.fraxExp(temp, a, b)).to.equal(i ** a);
        }
      }
    }
  });
});
