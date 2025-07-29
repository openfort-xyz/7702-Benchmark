#!/usr/bin/env ts-node

import * as fs from 'fs';
import * as path from 'path';
import { p256 } from '@noble/curves/p256';
import { randomBytes } from 'crypto';

// Type definitions
type Hex = `0x${string}`;

interface NetworkSignatureData {
  challenge: Hex;
  x: Hex;
  y: Hex;
  r: Hex;
  s: Hex;
}

interface ResultData {
  [networkName: string]: NetworkSignatureData;
}

/* ────────────────────────────────────────────── helper: hex utils ── */
const toHex = (bytes: Uint8Array): Hex =>
  `0x${Buffer.from(bytes).toString("hex")}` as Hex;

const toHex32 = (n: bigint): Hex =>
  `0x${n.toString(16).padStart(64, "0")}` as Hex;

const bigintToHex = (n: bigint): Hex => toHex32(n);

const hexToBytes = (hex: Hex): Uint8Array => {
  const cleanHex = hex.startsWith('0x') ? hex.slice(2) : hex;
  return new Uint8Array(Buffer.from(cleanHex, 'hex'));
};

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

/* ──────────────────────────────────────────────────────────── main ── */
const generateP256Data = async (): Promise<ResultData> => {
  // Define the challenges to sign
  const challenges: Hex[] = [
    '0x24eadaac7c180fddc200cf37233ebcf234779f8520b842cc0d2fe9fe0b70a7b0',
    '0xbb9303afda86dbf78919f6ca18213db3b3bae2ad92e73fead5488f573125b800',
    '0x2b8b43c7df208f706bab33bc3245e444b004b269ae4168fb9be8b2a99ab7a43c',
    '0xba1ecdf6684389e5b980a175d8d5e78c73f4b0bf0d294d1e61c81821491185ee'
  ];

  // Define the network names corresponding to each challenge
  const networks: string[] = ['MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM'];

  /* 1️⃣  GENERATE KEY PAIR ------------------------------------------ */
  // Generate a random private key
  const privateKeyBytes = randomBytes(32);
  const privateKey = privateKeyBytes;
  
  // Get the public key from private key
  const publicKeyBytes = p256.getPublicKey(privateKey, false); // uncompressed format
  
  // Extract x and y coordinates (skip the first byte which is 0x04 for uncompressed)
  const xBytes = publicKeyBytes.slice(1, 33);
  const yBytes = publicKeyBytes.slice(33, 65);
  
  const xHex: Hex = toHex(xBytes);
  const yHex: Hex = toHex(yBytes);

  console.log("🔑 Generated key pair");
  console.log("Private key:", toHex(privateKey));
  console.log("Public key coordinates - x:", xHex, "y:", yHex);

  // Initialize the result object
  const result: ResultData = {};

  /* 2️⃣  SIGN EACH CHALLENGE ---------------------------------------- */
  for (let i = 0; i < challenges.length; i++) {
    const challenge = challenges[i];
    const network = networks[i];

    console.log(`\n🔐 Signing ${network} challenge: ${challenge}`);

    // Convert challenge hex to bytes
    const challengeBytes = hexToBytes(challenge);

    /* 3️⃣  SIGN -------------------------------------------------------- */
    const signature = p256.sign(challengeBytes, privateKey);
    
    const rBig = signature.r;
    const sBig = signature.s;
    
    console.log(`${network} signature components - r:`, rBig.toString(), "s:", sBig.toString());

    let rHex: Hex = bigintToHex(rBig);
    let sHex: Hex = bigintToHex(sBig);

    // Normalize the signature (ensure s is in lower half)
    const normalized = normalizeP256Signature(rHex, sHex);
    rHex = normalized.r;
    sHex = normalized.s;

    console.log(`${network} normalized r as hex:`, rHex);
    console.log(`${network} normalized s as hex:`, sHex);

    /* 4️⃣  VERIFY (sanity-check) -------------------------------------- */
    const isValid = p256.verify(signature, challengeBytes, publicKeyBytes);

    console.log(`${network} signature verification result:`, isValid);

    if (isValid) {
      console.log(`✅ ${network} signature is VALID!`);
    } else {
      console.log(`❌ ${network} signature is INVALID!`);
      throw new Error(`Invalid signature for ${network}`);
    }

    // Add to result object in the required format
    result[network] = {
      challenge: challenge,
      x: xHex,
      y: yHex,
      r: rHex,
      s: sHex
    };
  }

  /* 5️⃣  WRITE TO FILE ---------------------------------------------- */
  console.log("\n📦 Final result object:", result);

  // Ensure the directory exists
  const outputDir = path.join(process.cwd(), 'test', 'Data');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  const outputPath = path.join(outputDir, 'BatchP256.json');
  
  fs.writeFileSync(
    outputPath,
    JSON.stringify(result, null, 4) // Using 4 spaces for indentation to match your format
  );

  console.log(`✅ File written to ${outputPath}`);

  return result;
};

// Run the script
const main = async (): Promise<void> => {
  try {
    await generateP256Data();
    console.log("🎉 Script completed successfully!");
  } catch (error) {
    console.error("❌ Script failed:", error);
    process.exit(1);
  }
};

// Execute if this file is run directly
if (require.main === module) {
  main();
}

export { generateP256Data };