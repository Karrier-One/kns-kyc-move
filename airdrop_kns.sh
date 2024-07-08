#!/bin/bash
current_date=$(date +%F)
#sui client call --package 0xf7de9df2c6e85db7b8a29bc1085bd45f35c2e0454de766596d2a172d5772897a --module kns --function airdrop --args "0xb8115e8e269b0f27ffd13c8f9fce50e6934239d025f8ac6f4b63cde12fc01403" '[0x2567d98ad32168293b4da76f5a00c1662345181a762895d955a76d19cfb916f6]' --gas-budget 5000000
sui client call --package 0x695fa0bd4395696074c4b9e8d2122e40664c0a78842c356095ed28ccdc04a802 --module kns --function airdrop --args "0x307f9495bd47f13080d25a4667533aab702491203c6c497513176470fdc5adb4" '0x98703142a8aa8b5a479b6d7dfbe567bb02cfa15e26c4e02cb66780c93d452b9b' --gas-budget 5000000 | tee "airdrop_kns.${current_date}.txt"
