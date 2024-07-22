// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/GaussianCDF.sol";

contract GaussianCDFTest is Test {
    function testFuzzGaussianCDF(int256 x, int256 mu, int256 sigma) public {
        // Bound the inputs to the specified ranges
        x = bound(x, -1e23, 1e23);
        mu = bound(mu, -1e20, 1e20);
        sigma = bound(sigma, 1, 1e19);
        console.log("x", x);
        console.log("mu", mu);
        console.log("sigma", sigma);

        // Call the gaussianCDF function
        int256 result = GaussianCDF.cdf(x, mu, sigma);

        int256 expectedResult = getExpectedCDF(x, mu, sigma);
        assertApproxEqAbs(result, expectedResult, 1e8, "Expected result should match within 1e-8");
    }

    // Helper function to test specific cases
    function testSpecificCases() public {
        testFuzzGaussianCDF(1e18, 0, 1e18);
        testFuzzGaussianCDF(0, 0, 1e18);
        testFuzzGaussianCDF(1e23, 0, 1e18);
        testFuzzGaussianCDF(-1e23, 0, 1e18);
    }

    // Call `yarn tsx reference/main.ts x mu sigma --ffi` to get the expected result
    function getExpectedCDF(int256 x, int256 mu, int256 sigma) public returns (int256) {
        string[] memory args = new string[](7);
        args[0] = "yarn";
        args[1] = "tsx";
        args[2] = "reference/main.ts";
        args[3] = vm.toString(x);
        args[4] = vm.toString(mu);
        args[5] = vm.toString(sigma);
        args[6] = "--ffi";
        bytes memory res = vm.ffi(args);
        int256 expectedResult = abi.decode(res, (int256));
        return expectedResult;
    }
}
