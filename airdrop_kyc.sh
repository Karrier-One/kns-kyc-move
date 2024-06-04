#!/bin/bash
current_date=$(date +%F)
#sui client call --package 0xf7de9df2c6e85db7b8a29bc1085bd45f35c2e0454de766596d2a172d5772897a --module kns --function airdrop --args "0xb8115e8e269b0f27ffd13c8f9fce50e6934239d025f8ac6f4b63cde12fc01403" '[0x2567d98ad32168293b4da76f5a00c1662345181a762895d955a76d19cfb916f6]' --gas-budget 5000000
sui client call --package 0x5b790aefd3e3014da9a2e7ee381d130fa05c9e46f08f920f0c496b1e458f66a4 --module kyc --function airdrop --args "0x5d708e7429d7ada794be29485cd943b12de880571d5371c04e8c7ee8cb9790f2" '0x98703142a8aa8b5a479b6d7dfbe567bb02cfa15e26c4e02cb66780c93d452b9b' --gas-budget 5000000 | tee "airdrop_kyc.${current_date}.txt"
