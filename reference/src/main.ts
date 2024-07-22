// Simple cli tool to calculate the Gaussian CDF for a given x, mu, and sigma

import gaussian from "gaussian";

function main() {
  const x = parseFloat(process.argv[2]);
  const mu = parseFloat(process.argv[3]);
  const sigma = parseFloat(process.argv[4]);

  console.log("x:", x);
  console.log("mu:", mu);
  console.log("sigma:", sigma);

  if (x === undefined || mu === undefined || sigma === undefined) {
    console.error("Usage: node src/main.ts x mu sigma");
    process.exit(1);
  }

  // const distribution = new gaussian(mu, sigma);
  // // Print result as 18 decimal fixed point

  // const res = distribution.cdf(x);
  const res = cdf(x, mu, sigma);
  console.log("Gaussian CDF:", res);
  console.log(res * 1e18);
}

main();

function cdf(x: number, mu: number, sigma: number) {
  return 0.5 * erfc(-(x - mu) / (sigma * Math.sqrt(2)));
}

function erfc(x: number) {
  var z = Math.abs(x);
  var t = 1 / (1 + z / 2);
  var inner =
    -z * z -
    1.26551223 +
    t *
      (1.00002368 +
        t *
          (0.37409196 +
            t *
              (0.09678418 +
                t *
                  (-0.18628806 +
                    t *
                      (0.27886807 +
                        t *
                          (-1.13520398 +
                            t *
                              (1.48851587 +
                                t * (-0.82215223 + t * 0.17087277))))))));
  console.log("erfc inner", inner);
  var r = t * Math.exp(inner);
  return x >= 0 ? r : 2 - r;
}
