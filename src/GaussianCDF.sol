// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {FixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";
import "forge-std/console.sol";

library GaussianCDF {
    using FixedPointMathLib for int256;

    int256 constant FIXED_1 = 1e18;
    int256 constant FIXED_2 = 2e18;

    int256 constant SQRT_2 = 141421356237309504880168872420969808; // sqrt(2) 35 decimals

    function cdf(int256 x, int256 mu, int256 sigma) internal view returns (int256) {
        // function cdf(x: number, mu: number, sigma: number) {
        //   return 0.5 * erfc(-(x - mu) / (sigma * Math.sqrt(2)));
        // }

        int256 denom = sigma * SQRT_2 / 1e35;
        int256 numer = mu - x;
        int256 inner = numer.sDivWad(denom);
        int256 res = erfc(inner);
        return res / 2;
    }

    int256 constant c = 1265512230000000000;
    int256 constant a1 = 1000023680000000000;
    int256 constant a2 = 374091960000000000;
    int256 constant a3 = 96784180000000000;
    int256 constant a4 = -186288060000000000;
    int256 constant a5 = 278868070000000000;
    int256 constant a6 = -1135203980000000000;
    int256 constant a7 = 1488515870000000000;
    int256 constant a8 = -822152230000000000;
    int256 constant a9 = 170872770000000000;

    function erfc(int256 x) public pure returns (int256) {
        // var z = Math.abs(x);
        // var t = 1 / (1 + z / 2);
        // var r = t * Math.exp(-z * z - 1.26551223 + t * (1.00002368 +
        //         t * (0.37409196 + t * (0.09678418 + t * (-0.18628806 +
        //         t * (0.27886807 + t * (-1.13520398 + t * (1.48851587 +
        //         t * (-0.82215223 + t * 0.17087277)))))))))
        // return x >= 0 ? r : 2 - r;

        console.log("erfc1");
        int256 z = x >= 0 ? x : -x;
        console.log("erfc2");
        int256 t = FIXED_1.sDivWad(FIXED_1 + z / 2);
        console.log("erfc3");
        console.log("z", z);
        console.log("t", t);
        int256 z_test = 707106781186547524;
        console.log("int256 max", type(int256).max);
        console.log("z_test", z_test);
        console.log("z * z", z_test * z_test);
        int256 z_2 = -(z.sMulWad(z));
        // int256 z_2 = -(z.powWad(FIXED_2));
        console.log("z_2", z_2);
        int256 inner = (
            (-z).sMulWad(z) - c
                + t.sMulWad(
                    a1
                        + t.sMulWad(
                            a2
                                + t.sMulWad(
                                    a3
                                        + t.sMulWad(a4 + t.sMulWad(a5 + t.sMulWad(a6 + t.sMulWad(a7 + t.sMulWad(a8 + t.sMulWad(a9))))))
                                )
                        )
                )
        );
        console.log("erfc4");
        int256 r = t.sMulWad(inner.expWad());
        console.log("erfc5");
        return x >= 0 ? r : FIXED_2 - r;
    }
}
