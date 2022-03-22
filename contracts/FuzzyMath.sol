//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// only valid for x ≤ 10e8
// https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.569.8009&rep=rep1&type=pdf
contract FuzzyMath {
	function fraxExp(uint x, uint8 a, uint8 b) public pure returns (uint est)  {
		// check for potential overflow 
        // require(
		// 	a*xBound <= 78,
		// 	"uint256 overflow risk: a*xBound <= 78; where xBound = ceil( log2(x) )"
		// );
        require(b > 1, "why are you using this library..");

        // shortcut this nonsense
        if (a % b == 0) {
            return x ** (a / b);
        }

        // calculate subtotal with numerator        
        x = (a > 1) ? x**a : x; 

        // calculate b-root of subtotal
        if (b == 2) { 
            est = sqrt(x); // efficient shortcut
        } else {
            uint b2 = b - 1;
            uint z = (x + 1) / 2; // what's a better guess? too large causes overflow (maybe dependent on a)
            est = x;
            while (z < est) {
                est = z;
                z = (x / z**b2  + b2 * z) / b;
            }
        }
	}

    function sqrt(uint x) pure internal returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}