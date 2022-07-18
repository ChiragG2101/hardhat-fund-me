const networkConfig = {
    4: {
        name: "rinkeby",
        ethUsdPriceFeed: "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e",
    },
    137: {
        name: "Polygon",
        ethUsdPriceFeed: "0xC741F7752BAe936fCE97933b755884AF66fB69C1",
    },
}

const developmentChains = ["hardhat", "localhost"]
const DECIMALS = 8
const INTIAL_ANSWER = 2000000000

module.exports = {
    networkConfig,
    developmentChains,
    DECIMALS,
    INTIAL_ANSWER,
}
