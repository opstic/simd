//! SIMD-accelerated Unicode validation and transcoding
//!
#![doc=vsimd::shared_docs!()]
//
#![cfg_attr(not(any(feature = "std", test)), no_std)]
#![cfg_attr(feature = "unstable", feature(arm_target_feature))]
#![cfg_attr(docsrs, feature(doc_cfg))]
#![cfg_attr(test, deny(warnings))]
//
#![deny(
    missing_debug_implementations,
    missing_docs,
    clippy::all,
    clippy::pedantic,
    clippy::cargo,
    clippy::missing_inline_in_public_items
)]
#![warn(clippy::todo)]
#![allow(clippy::inline_always)]

#[cfg(feature = "alloc")]
extern crate alloc;

mod ascii;
mod utf16;
mod utf32;

mod multiversion;

pub use outref::OutRef;

// ------------------------------------------------------------------------------------------------

use vsimd::tools::slice_mut;

/// Checks if `data` is a valid ASCII string, in constant-time.
///
/// This function always scans the entire input
/// without data-dependent branches or lookup tables.
///
/// This function is faster than the short-circuiting version
/// if the inputs are mostly valid ASCII strings.
#[inline]
#[must_use]
pub fn is_ascii_ct(data: &[u8]) -> bool {
    crate::multiversion::is_ascii_ct::auto(data)
}

/// TODO: test, bench
#[inline]
#[must_use]
pub fn is_utf32le_ct(data: &[u32]) -> bool {
    crate::multiversion::is_utf32le_ct::auto(data)
}

/// TODO: test, bench
#[inline]
pub fn utf32_swap_endianness_inplace(data: &mut [u32]) {
    let len = data.len();
    let dst = data.as_mut_ptr();
    let src = dst;
    unsafe { crate::multiversion::utf32_swap_endianness::auto(src, len, dst) }
}

/// TODO: test, bench
///
/// # Panics
/// This function asserts that `src.len() <= dst.len()`
#[inline]
#[must_use]
pub fn utf32_swap_endianness<'s, 'd>(src: &'s [u32], mut dst: OutRef<'d, [u32]>) -> &'d mut [u32] {
    assert!(src.len() <= dst.len());
    let len = src.len();
    let src = src.as_ptr();
    let dst = dst.as_mut_ptr();
    unsafe { crate::multiversion::utf32_swap_endianness::auto(src, len, dst) };
    unsafe { slice_mut(dst, len) }
}

/// TODO: test, bench
#[inline]
pub fn utf16_swap_endianness_inplace(data: &mut [u16]) {
    let len = data.len();
    let dst = data.as_mut_ptr();
    let src = dst;
    unsafe { crate::multiversion::utf16_swap_endianness::auto(src, len, dst) }
}

/// TODO: test, bench
///
/// # Panics
/// This function asserts that `src.len() <= dst.len()`
#[inline]
#[must_use]
pub fn utf16_swap_endianness<'s, 'd>(src: &'s [u16], mut dst: OutRef<'d, [u16]>) -> &'d mut [u16] {
    assert!(src.len() <= dst.len());
    let len = src.len();
    let src = src.as_ptr();
    let dst = dst.as_mut_ptr();
    unsafe { crate::multiversion::utf16_swap_endianness::auto(src, len, dst) };
    unsafe { slice_mut(dst, len) }
}
