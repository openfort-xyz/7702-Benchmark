// src/p256Data.ts
import { p256 } from "@noble/curves/p256";
import type { Hex } from "viem";
import { fromHex } from 'viem';
import { writeFileSync } from 'fs';
import { WebCryptoP256 } from "ox";

/** P-256 curve order (𝑛) */
const P256_N = BigInt(
  "0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551"
);

/* ────────────────────────────────────────────── helper: normalize ── */
function normalizeP256Signature(
  r: Hex,
  s: Hex
): { r: Hex; s: Hex } {
  const sBig = BigInt(s);
  const halfN = P256_N / 2n;

  if (sBig > halfN) {
    const sNormalized = P256_N - sBig;
    const sHex = `0x${sNormalized.toString(16).padStart(64, "0")}` as Hex;
    return { r, s: sHex };
  }
  return { r, s };
}

/* ────────────────────────────────────────────── helper: hex utils ── */
const toHex = (bytes: Uint8Array): Hex =>
  `0x${Buffer.from(bytes).toString("hex")}` as Hex;

const toHex32 = (n: bigint): Hex =>
  `0x${n.toString(16).padStart(64, "0")}` as Hex;

const bigintToHex = (n: bigint): Hex => toHex32(n);

/* ──────────────────────────────────────────────────────────── main ── */
export const p256Data = (async () => {
  // Define the 15 challenges
  const challenges = [
    '0x19f15de2bdee93bd00abcbb19fa12d777d27e08c163c3341ae1034ef70665341',
    '0xcc80bd094a1dddd1250e96c5e42a2b6f8c7677531ce3808b04a2429c799ebbc5',
    '0x13e8c9d00bad45c65a9a43d7cee2adc65aafc2e341dc7a01e5d48b26e517f6d2',
    '0x04f586c4d3b10cb82ba06f8a320e8cc43dd9ecd910fe006b4aa7c1cdf79fc90d',
    '0x3e339640ddb606c9307bba278210362fc8039f3affed854e6c1cb96f5149eda7',
    '0x9d7b85265237f62c1e166cf91d2d8eb5699fe77918df2595514464e04477e306',
    '0xc89c1968b0009dc2c4f3ec7fce0a547d3257cdc46b680286214a69b5520dd051',
    '0x3f8567199f37a454e6595de15c92b9b90ab7f276d3a3c958abf878bb8093f79e',
    '0xfe8e6bbff59dd38c2e8ef9d926f56c0be6f471c7d7efdcca20ffb24c11078ab5',
    '0x8c52ebfa2f7f4ecce1b7948de9ae3078d790fe3bd0770eecd0a028d42c4008c6',
    '0xd03bef0297cd9405c39914dbf08d0f0480eb4e66632f31e48b83f9799f07ffc7',
    '0x47903c9c5c6c922d65cec275c555c19e6b2f7b920eab3fa069cfc372cbf260ce',
    '0x0385e1cc6eda1408f26675a63b4469588c8a5f2ead80131a53b8145a67918309',
    '0x59f49396acbe4c7ebb7d1176850db1a7f0d04a52c1e0c18e08cc1443cc7b6d17',
    '0xd79109004414ec7e6a60353dad3f9bd26ff243f26a4e53cad9e5d24c8dfc060e',
  ];

  // Mapping of challenges to their scenario and mode
  const CHALLENGE_MAPPING = [
    { scenario: 'empty', mode: 'DirectAA' },           // Challenge 1
    { scenario: 'empty', mode: 'AASponsored' },        // Challenge 2
    { scenario: 'empty', mode: 'AASponsoredERC20' },   // Challenge 3
    { scenario: 'native', mode: 'DirectAA' },          // Challenge 4
    { scenario: 'native', mode: 'AASponsored' },       // Challenge 5
    { scenario: 'native', mode: 'AASponsoredERC20' },  // Challenge 6
    { scenario: 'transferERC20', mode: 'DirectAA' },   // Challenge 7
    { scenario: 'transferERC20', mode: 'AASponsored' }, // Challenge 8
    { scenario: 'transferERC20', mode: 'AASponsoredERC20' }, // Challenge 9
    { scenario: 'batch10', mode: 'DirectAA' },         // Challenge 10
    { scenario: 'batch10', mode: 'AASponsored' },      // Challenge 11
    { scenario: 'batch10', mode: 'AASponsoredERC20' }, // Challenge 12
    { scenario: 'uniswapV2', mode: 'DirectAA' },       // Challenge 13
    { scenario: 'uniswapV2', mode: 'AASponsored' },    // Challenge 14
    { scenario: 'uniswapV2', mode: 'AASponsoredERC20' }, // Challenge 15
  ];

  // Generate key pairs once
  const privKey = p256.utils.randomPrivateKey();
  const pubKey = p256.getPublicKey(privKey, false);
  const P256_xHex = toHex(pubKey.slice(1, 33));
  const P256_yHex = toHex(pubKey.slice(33));

  const keyPair = await WebCryptoP256.createKeyPair();
  console.log("🔑 Key pairs generated");
  console.log("P256 public key (x, y):", P256_xHex, P256_yHex);
  console.log("WebCrypto public key (x, y):", toHex32(keyPair.publicKey.x), toHex32(keyPair.publicKey.y));

  // Build the output structure
  const output: any = {};

  console.log('\n🔐 Signing challenges...');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  // Sign each challenge
  for (let i = 0; i < challenges.length; i++) {
    const { scenario, mode } = CHALLENGE_MAPPING[i];
    const challengeHex = challenges[i];
    const challengeBytes = fromHex(challengeHex, 'bytes');

    // Sign with p256 (@noble/curves)
    const signature = p256.sign(challengeBytes, privKey);
    const rHex = bigintToHex(signature.r);
    const sHex = bigintToHex(signature.s);
    const { r: P256_lowSR, s: P256_lowSS } = normalizeP256Signature(rHex, sHex);
    const isValidSignature = p256.verify(signature, challengeBytes, pubKey);

    // Sign with WebCryptoP256
    const { r, s } = await WebCryptoP256.sign({
      privateKey: keyPair.privateKey,
      payload: challengeHex,
    });
    const P256NONKEY_rHex = bigintToHex(r);
    const P256NONKEY_sHex = bigintToHex(s);
    const isValid = await WebCryptoP256.verify({
      publicKey: keyPair.publicKey,
      payload: challengeHex,
      signature: { r, s }
    });

    console.log(`✅ Signed ${scenario}.${mode}`);

    // Build result objects
    const result = {
      P256_hashHex: challengeHex,
      P256_lowSR,
      P256_lowSS,
      P256_xHex,
      P256_yHex,
      challenge: challengeHex,
      rBigInt: signature.r.toString(),
      sBigInt: signature.s.toString(),
      recovery: signature.recovery,
      isValidSignature,
    };

    const result2 = {
      P256NONKEY_hashHex: challengeHex,
      P256NONKEY_rHex,
      P256NONKEY_sHex,
      P256NONKEY_xHex: toHex32(keyPair.publicKey.x),
      P256NONKEY_yHex: toHex32(keyPair.publicKey.y),
      challenge: challengeHex,
      webauthnData: {
        r: r.toString(),
        s: s.toString()
      },
      isValidSignature: isValid,
    };

    // Initialize scenario object if it doesn't exist
    if (!output[scenario]) {
      output[scenario] = {};
    }

    // Add to output structure
    output[scenario][mode] = {
      result,
      result2
    };
  }

  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('✅ All signatures collected!\n');

  // Save to file
  console.log('📋 Saving to: test/data/signers/P256SessionKey.json');
  console.log('═══════════════════════════════════════════════════════════════════');
  writeFileSync(
    "test/data/signers/P256SessionKey.json",
    JSON.stringify(output, null, 2)
  );
  console.log('═══════════════════════════════════════════════════════════════════');
  console.log('✅ File saved successfully!');

  return output;
})();