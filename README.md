# simd

[![MIT licensed][mit-badge]][mit-url]

[mit-badge]: https://img.shields.io/badge/license-MIT-blue.svg
[mit-url]: ./LICENSE

SIMD-accelerated operations

|                crate                 |                                                version                                                |                                      docs                                      |
| :----------------------------------: | :---------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------: |
| [base64-simd](./crates/base64-simd/) | [![Crates.io](https://img.shields.io/crates/v/base64-simd.svg)](https://crates.io/crates/base64-simd) | [![Docs](https://docs.rs/base64-simd/badge.svg)](https://docs.rs/base64-simd/) |
|    [hex-simd](./crates/hex-simd/)    |    [![Crates.io](https://img.shields.io/crates/v/hex-simd.svg)](https://crates.io/crates/hex-simd)    |    [![Docs](https://docs.rs/hex-simd/badge.svg)](https://docs.rs/hex-simd/)    |
|   [uuid-simd](./crates/uuid-simd/)   |   [![Crates.io](https://img.shields.io/crates/v/uuid-simd.svg)](https://crates.io/crates/uuid-simd)   |   [![Docs](https://docs.rs/uuid-simd/badge.svg)](https://docs.rs/uuid-simd/)   |

The crates automatically select SIMD functions when available and provide fast fallback implementations. Benchmark results are available in [Benchmark Dashboard](https://github.com/Nugine/simd/issues/25).

这些 crate 自动选择可用的 SIMD 函数并提供快速的回退实现。基准测试结果可在 [Benchmark Dashboard](https://github.com/Nugine/simd/issues/25) 查看。

## Goals

+ Performance: To be the fastest
+ Productivity: Efficient SIMD abstractions
+ Ergonomics: Easy to use

- 性能：做到最快
- 生产力：高效的 SIMD 抽象
- 人体工程学：易于使用

## Safety

This project relies heavily on unsafe code. We encourage everyone to review the code and report any issues.

Memory safety bugs and unsoundness issues are classified as critical bugs. They will be fixed as soon as possible.

本项目高度依赖不安全的代码。我们鼓励每个人审查代码并报告任何问题。

内存安全错误和健全性问题被归类为致命错误。它们将被尽快修复。

## Spoken Language

This project accepts English or Chinese. All code, docs, PRs and issues should be written in English or Chinese.

本项目接受中文或英文。所有代码、文档、PR 和议题都应该使用中文或英文编写。

## References

This project includes multiple algorithms and implementations. Some of them are not original. We list the references here.

本项目包含多种算法和实现。其中一些不是原创的。我们在这里列出参考资料。

base64:

+ <http://0x80.pl/articles/index.html#base64-algorithm-new>
+ <https://gist.github.com/aqrit/a2ccea48d7cac7e9d4d99f19d4759666>

hex:

+ <http://0x80.pl/notesen/2022-01-17-validating-hex-parse.html>

unicode:

+ Daniel Lemire, Wojciech Muła,  [Transcoding Billions of Unicode Characters per Second with SIMD Instructions](https://arxiv.org/abs/2109.10433), Software: Practice and Experience (to appear)
+ <https://github.com/simdutf/simdutf>
