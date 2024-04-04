const { deployments, ethers, getNamedAccounts } = require("hardhat")
const { assert } = require("chai")

describe("FundMe", async () => {
    beforeEach(async function () {
        let fundMe
        let deployer
        let MockV3Aggregator
        //deploy our fundme contract
        // using hardhat deploy
        deployer = (await getNamedAccounts()).deployer
        await deployments.fixture(["all"])
        fundMe = await ethers.getContractAt("FundMe", deployer)
        MockV3Aggregator = await ethers.getContractAt(
            "MockV3Aggregator",
            deployer,
        )
    })

    describe("constructor", async () => {
        it("sets the aggregator addresses correctly", async function () {
            const response = await fundMe.priceFeed
            assert.equal(response, MockV3Aggregator.address)
        })
    })
})
