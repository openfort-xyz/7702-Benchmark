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
    '0x4d565978a82a98ccf6e2c5c4ed19645fd05339c2b2fdb9659ceacb76464c8616',
    '0x12a21cc574af878ab4e3f88617fab16cd3f04d7e6809561c55560a9a78f98e19',
    '0xafa14c650f61237a062678e802fcab8721b4895d5750efa414fba40822eb1975',
    '0x7fc6bbb0eb16079439e1bde52bcd52208986c5a725a64e9a8058a4eeda9606e5',
    '0xc9948ee94fb703091bfc81999a261065f985e9091fbf52e4b654c4c6c75e5264',
    '0x8870174cacea0ff1255f4a485f19b3e81f883273593e1782e7bd15e303ef2841',
    '0x4bc65629eb07d6adcc1b3d696917a3f4fc5b0128de954b759be986c0a2e9a9be',
    '0x27d5f1041ab460b6748b57fffd953340bb66707e5afda7682df6247c988f8741',
    '0x0e03cc23cab90812eb228d302fdc0bf702dd3344481aa04d3904147576a72599',
    '0x104e70524d439547c45b21b71bebf925315e8b621a325de9cfb002ac5008288b',
    '0xebffeddb404273172f69c75dca688430e775cb502f3d9682bac7bc7a02d1fa42',
    '0x0eaa9160b7e290aed1cb981d5bccdc1198b02df797bd374446e1376804633dfe',
    '0xbbb702b4bcd4939eddc0b8a34d21c726ded22d2c7579c95e24355582038ad33f',
    '0x771d16b9cabaa624ca2fbdf2b0a5dc9a2893a611cdfd07293e955820a0c34415',
    '0xddbad98c3e18d981913eb41f2b21a5c82b72f721df4f107615fcb2a05888be61',
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