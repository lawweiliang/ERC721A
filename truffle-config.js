const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();
const mnemonic = process.env.MNEMONIC_PHRASE;
const infuraProjectId = process.env.INFURA_PROJECT_ID;
const etherScanApiKey = process.env.ETHERSCAN_API_KEY;
const coinMarketcapApiKey = process.env.COINMARKETCAP_API_KEY;

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraProjectId}`),
      network_id: 4,
      gas: 5500000,
      skipDryRun: true,
    },
  },
  mocha: {
    reporter: 'eth-gas-reporter',
    reporterOptions: {
      currency: 'USD',
      coinmarketcap: coinMarketcapApiKey,
      gasPriceApi: etherScanApiKey,
    },
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    etherscan: etherScanApiKey,
  },
  compilers: {
    solc: {
      version: 'pragma',
      settings: {
        optimizer: {
          enabled: true,
        },
      },
    },
  },
};
