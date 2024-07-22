// Simple cli tool to calculate the Gaussian CDF for a given x, mu, and sigma

import gaussian from "gaussian";

function main() {
  let x = parseFloat(process.argv[2]);
  let mu = parseFloat(process.argv[3]);
  let sigma = parseFloat(process.argv[4]);
  let ffiMode = false;
  for (let arg of process.argv) {
    if (arg === "--ffi") {
      ffiMode = true;
      break;
    }
  }
  if (ffiMode) {
    x /= 1e18;
    mu /= 1e18;
    sigma /= 1e18;
  }

  // console.log("x:", x);
  // console.log("mu:", mu);
  // console.log("sigma:", sigma);

  if (x === undefined || mu === undefined || sigma === undefined) {
    console.error("Usage: yarn tsx src/main.ts x mu sigma");
    process.exit(1);
  }

  const distribution = new gaussian(mu, sigma);
  const res = distribution.cdf(x);

  // Print result as 18 decimal fixed point abi-encoded hex-encoded string
  if (ffiMode) {
    const resInt256 = Math.round(res * 1e18);
    const encoded = resInt256.toString(16).padStart(64, "0");
    console.log(encoded);
  } else {
    console.log(res);
  }
}

main();
