#!/bin/bash
current_date=$(date +%F)
#sui client call --package 0xf7de9df2c6e85db7b8a29bc1085bd45f35c2e0454de766596d2a172d5772897a --module kns --function airdrop --args "0xb8115e8e269b0f27ffd13c8f9fce50e6934239d025f8ac6f4b63cde12fc01403" '[0x2567d98ad32168293b4da76f5a00c1662345181a762895d955a76d19cfb916f6]' --gas-budget 5000000
sui client call --package 0xfea85302b13013d6015482e4ab998a01ff61684fb112b323cc9b3c2642365ac5 --module kns --function airdrop --args "0xe301e1284795605fd8e8c3e5550a86c2a42f325e7615fac38173bdd4ee92a05b" '0xf87ea7d2d19df780f45519845f2772eab35b6dcdfbfcd504f6d28931bdb50aac' --gas-budget 5000000 | tee "airdrop_kns.${current_date}.txt"
