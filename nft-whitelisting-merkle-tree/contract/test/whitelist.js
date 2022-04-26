const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("It should deploy the NFTWhitelist contract", function () {
    before(async function () {
        const NFT = await ethers.getContractFactory("NFTWhitelist");
        const nft = await NFT.deploy("My Personal NFT", "MPN", "0xfda3f793697acd377664e59987caa4b3a5c2118237e6c2889510a484a18b4ea3");
        await nft.deployed();

    })
    it("Should deploy", async function () {


        // expect(await nft.claim()).to.equal("0xdcefC49F4F8Abc6fDf5e1B0AcaCC5A4e8FE6dbA2", );

        // const setGreetingTx = await nftWhitelist.setGreeting("Hola, mundo!");

        // // wait until the transaction is mined
        // await setGreetingTx.wait();

        // expect(await nftWhitelist.greet()).to.equal("Hola, mundo!");
    });
});
