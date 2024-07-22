// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/GaussianCDF.sol";

contract GaussianCDFTest is Test {
    function testFuzzGaussianCDF(int256 x, int256 mu, int256 sigma) public view {
        // Bound the inputs to the specified ranges
        x = bound(x, -1e41, 1e41);
        mu = bound(mu, -1e38, 1e38);
        sigma = bound(sigma, 1, 1e37); // Ensure sigma is positive and within range
        vm.assume(sigma > 0);
        vm.assume(sigma <= 1e37);
        vm.assume(mu >= -1e38);
        vm.assume(mu <= 1e38);
        vm.assume(x >= -1e38);
        vm.assume(x <= 1e38);

        assert(sigma > 0);
        assert(sigma <= 1e37);
        assert(mu >= -1e38);
        assert(mu <= 1e38);
        assert(x >= -1e38);
        assert(x <= 1e38);
        console.log("x", x);
        console.log("mu", mu);
        console.log("sigma", sigma);

        // Call the gaussianCDF function
        int256 result = GaussianCDF.cdf(x, mu, sigma);

        // Basic sanity checks
        assertTrue(result >= 0 && result <= 1e18, "CDF should be between 0 and 1");

        // // Check symmetry property: CDF(-x) = 1 - CDF(x) for standard normal distribution
        // if (mu == 0 && sigma == 1e18) {
        //     // 1e18 represents 1.0 in our fixed-point representation
        //     int256 resultNegX = GaussianCDF.gaussianCDF(-x, mu, sigma);
        //     int256 expectedSum = 1e18; // 1.0 in fixed-point
        //     int256 actualSum = result + resultNegX;
        //     assertApproxEqAbs(actualSum, expectedSum, 1e10, "Symmetry property violated");
        // }

        // Additional property checks can be added here
    }

    // Helper function to test specific cases
    function testSpecificCases() public {
        int256 result = GaussianCDF.cdf(1e18, 0, 1e18);
        console.log(result);
        // Test the median (should be very close to 0.5)
        // int256 result = gaussianCDF.gaussianCDF(0, 0, 1e18);
        // assertApproxEqAbs(result, 5e17, 1e10, "Median should be close to 0.5");

        // // Test a value far in the positive tail (should be very close to 1)
        // result = gaussianCDF.gaussianCDF(1e23, 0, 1e18);
        // assertApproxEqAbs(result, 1e18, 1e10, "Far positive value should be close to 1");

        // // Test a value far in the negative tail (should be very close to 0)
        // result = gaussianCDF.gaussianCDF(-1e23, 0, 1e18);
        // assertApproxEqAbs(result, 0, 1e10, "Far negative value should be close to 0");
    }
}
