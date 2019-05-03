const path = require("path");

/* var HDWalletProvider = require("./client/node_modules/truffle-hdwallet-provider");
var infura_apikey = "XXXXXX"; // Not pushing my key
var mnemonic = "twelve words you can find in metamask/settings/reveal seed words";  // Not pushing my seed words */

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
/*     ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey),
      network_id: 3
    } */
  }
};