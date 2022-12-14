require('dotenv').config()
require('@nomiclabs/hardhat-etherscan')
require('@nomiclabs/hardhat-ethers')
require('@nomicfoundation/hardhat-toolbox')

const accounts = [process.env.PRIVATE_KEY]

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: '0.8.11',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    hardhat: {
      forking: {
        url: `${process.env.INFURA_KEY}`,
        // url: "https://rpc.ankr.com/polygon",
      },
    },
    mumbai: {
      url: 'https://matic-mumbai.chainstacklabs.com',
      chainId: 80001,
      accounts,
    },
    polygon: {
      url: process.env.INFURA_KEY,
      chainId: 137,
      accounts,
    },
    goerli: {
      url: 'https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161	',
      chainId: 5,
      accounts,
    },
  },
  etherscan: {
    apiKey: {
      mumbai: process.env.ETHERSCAN,
    },
  },
}
