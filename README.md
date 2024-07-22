## Gaussian

> Implement a maximally optimized gaussian CDF on the EVM for arbitrary 18 decimal fixed point parameters x, μ, σ. Assume -1e20 ≤ μ ≤ 1e20 and 0 < σ ≤ 1e19. Should have an error less than 1e-8 vs errcw/gaussian for all x on the interval [-1e23, 1e23].

## Test

```bash
forge test --ffi
```

## Notes

- I used fuzz testing + forge FFI to call the actual library to test correctness.
- I didn't have time to make it work for all inputs; it overflows on some. It might be possible to fix by implementing bigint mul. Although, the input space seems extremely large so I'm not sure it's even feasible to return a correct result for all inputs.
- I used the exact algorithms from errcw/gaussian to minimize error to that library. There is likely a much more efficient algorithm for gaussian CDF in general but I didn't have time to research / implement and test further.
- There's probably lots of low hanging fruit for optimization, like using unsafe math in places, Yul, better algorithms, etc.
