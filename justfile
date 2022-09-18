dev:
    just fmt
    /usr/bin/time -v -o target/time-test-all.txt just test-all
    cat target/time-test-all.txt

doc pkg="vsimd":
    #!/bin/bash -e
    export RUSTDOCFLAGS="--cfg docsrs"
    cargo doc --no-deps --all-features
    cargo doc --open -p {{pkg}}

x86-bench *ARGS:
    #!/bin/bash -ex
    cd {{justfile_directory()}}
    COMMIT_HASH=`git rev-parse --short HEAD`
    export RUSTFLAGS="-C target-feature=+avx2 -C target-feature=+sse4.1"
    time cargo criterion -p simd-benches --history-id $COMMIT_HASH {{ARGS}}

js-bench:
    #!/bin/bash -e
    cd {{justfile_directory()}}

    F=./scripts/base64.js
    echo "running $F"
    echo

    echo "node" `node -v`
    node ./scripts/base64.js
    echo

    deno -V
    deno run --allow-hrtime ./scripts/base64.js
    echo

    echo "bun" `bun --version`
    bun ./scripts/base64.js
    echo

wasi-bench:
    #!/bin/bash -e
    cd {{justfile_directory()}}

    export RUSTFLAGS="-C target-feature=+simd128"
    cargo build --release --bins -p simd-benches --target wasm32-wasi
    F=./target/wasm32-wasi/release/simd-benches.wasm

    wasmer -V
    wasmer run --enable-all $F
    echo

    wasmtime -V
    wasmtime --wasm-features simd $F
    echo

    echo "node" `node -v`
    node --experimental-wasi-unstable-preview1 ./scripts/node-wasi.js $F
    echo

sync-version:
    #!/bin/bash -ex
    cd {{justfile_directory()}}
    cargo set-version -p simd-benches       '0.8.0-dev'
    cargo set-version -p uuid-simd          '0.8.0-dev'
    cargo set-version -p hex-simd           '0.8.0-dev'
    cargo set-version -p base64-simd        '0.8.0-dev'
    cargo set-version -p unicode-simd       '0.1.0-dev'
    cargo set-version -p base32-simd        '0.1.0-dev'
    cargo set-version -p vsimd              '0.1.0-dev'

fmt:
    #!/bin/bash -ex
    cd {{justfile_directory()}}
    cargo fmt
    # cargo sort -w > /dev/null


x86-test *ARGS:
    #!/bin/bash -ex
    cd {{justfile_directory()}}
    source ./scripts/test.sh
    cd {{invocation_directory()}}

    export RUSTFLAGS="-Zsanitizer=address -C target-feature=+avx2"
    x86_test --lib {{ARGS}}
    export RUSTFLAGS="-Zsanitizer=address -C target-feature=+sse4.1"
    x86_test --lib {{ARGS}}
    export RUSTFLAGS="-Zsanitizer=address"
    x86_test --lib {{ARGS}}
    export RUSTFLAGS="-C target-feature=+avx2"
    x86_test {{ARGS}}
    export RUSTFLAGS="-C target-feature=+sse4.1"
    x86_test {{ARGS}}
    export RUSTFLAGS=""
    x86_test {{ARGS}}

arm-test *ARGS:
    #!/bin/bash -ex
    cd {{justfile_directory()}}
    source ./scripts/test.sh
    cd {{invocation_directory()}}

    export RUSTFLAGS="-C target-feature=+neon"
    arm_test {{ARGS}}
    export RUSTFLAGS=""
    arm_test {{ARGS}}

wasm-test *ARGS:
    #!/bin/bash -ex
    cd {{justfile_directory()}}
    source ./scripts/test.sh
    cd {{invocation_directory()}}

    export RUSTFLAGS="-C target-feature=+simd128"
    wasm_test {{ARGS}}
    export RUSTFLAGS=""
    wasm_test {{ARGS}}

miri-test *ARGS:
    #!/bin/bash -ex
    cd {{invocation_directory()}}
    cargo miri test {{ARGS}}

test PKG *ARGS:
    #!/bin/bash -ex
    cd {{justfile_directory()}}/crates/{{PKG}}
    just x86-test  {{ARGS}}
    just arm-test  {{ARGS}}
    just wasm-test {{ARGS}}
    just miri-test {{ARGS}}

test-all:
    #!/bin/bash -ex
    cd {{justfile_directory()}}
    source ./scripts/test.sh

    members=()
    members+=("vsimd")
    members+=("uuid-simd")
    members+=("hex-simd")
    members+=("base64-simd")
    members+=("unicode-simd")
    members+=("base32-simd")

    function test_all() {
        pids=""
        for member in "${members[@]}"; do
            pushd crates/$member
            if [ ! -z "$DISABLE_PARALLEL" ]; then
                $1
            else
                $1 &
                pids+="$! "
            fi
            popd
        done
        for pid in $pids; do
            wait $pid
        done
    }

    export RUSTFLAGS="-Zsanitizer=address -C target-feature=+avx2"
    test_all 'x86_test --lib'
    export RUSTFLAGS="-Zsanitizer=address -C target-feature=+sse4.1"
    test_all 'x86_test --lib'
    export RUSTFLAGS="-Zsanitizer=address"
    test_all 'x86_test --lib'
    export RUSTFLAGS="-C target-feature=+avx2"
    test_all 'x86_test'
    export RUSTFLAGS="-C target-feature=+sse4.1"
    test_all 'x86_test'
    export RUSTFLAGS=""
    test_all 'x86_test'

    export RUSTFLAGS="-C target-feature=+neon"
    test_all 'arm_test'
    export RUSTFLAGS=""
    test_all 'arm_test'

    export RUSTFLAGS="-C target-feature=+simd128"
    DISABLE_PARALLEL=1 test_all 'wasm_test'
    export RUSTFLAGS=""
    DISABLE_PARALLEL=1 test_all 'wasm_test'

    test_all 'cargo miri test'
