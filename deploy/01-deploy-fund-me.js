//import
const { networkConfig } = require("../helper-hardhat-config")
const { network } = require("hardhat")
const {
    developmentChains,
    DECIMALS,
    INTIAL_ANSWER,
} = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    // hre = hardhat runtime deployment
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let ethUsdPriceFeedAddress
    if (developmentChains.includes(network.name)) {
        log("Local network detected! Deploying mocks...")
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }

    const args = [ethUsdPriceFeedAddress]
    const FundMe = await deploy("FundMe", {
        from: deployer,
        args: args, // put pricefeed address
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log("-----------------------------------")
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(FundMe.address, args)
    }
    log("-------------------------------------")
}
module.exports.tags = ["all", "fundme"]
