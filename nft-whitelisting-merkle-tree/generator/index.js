import fs from "fs";
import path from "path";
import url from "url";
import keccak256 from "keccak256";
import { MerkleTree } from "merkletreejs";
import addresses from "./configNFT.js";

function throwError(message) {
  throw new Error(`${message}`);
}

if (addresses === undefined) {
  throwError("Missing addresses in config file");
}

const leaves = addresses.map((x) => keccak256(x));
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root = tree.getRoot().toString("hex");

const __dirname = url.fileURLToPath(new URL(".", import.meta.url));
const outputPath = path.join(__dirname, "./merkleNFT.json");
const outputData = JSON.stringify({ root: root, tree: tree }, null, 2);

fs.writeFile(outputPath, outputData, (err) => {
  if (err) {
    throwError("An error occurred");
  }
  console.log("Merkle tree generated");
});

const leaf = keccak256("0xdcefC49F4F8Abc6fDf5e1B0AcaCC5A4e8FE6dbA2");
const proof = tree.getProof(leaf);
const verifyProof = tree.verify(proof, leaf, root);

// console.log("VERIFY PROOF", verifyProof);

// console.log("MERKLE_TREE", tree.toString());

// console.log("MERKLE_ROOT",root);
