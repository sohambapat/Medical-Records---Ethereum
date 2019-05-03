const path = require("path");
                               //  ./client/node_modules/truffle-hdwallet-provider
var HDWalletProvider = require("truffle-hdwallet-provider");
var infura_apikey = "528eb380a5044c07a934acf2ca7773e2"; // Not pushing my key
var mnemonic = "twin anchor library borrow output powder track coach tribe culture pear viable";  // Not pushing my seed words

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
    ropsten: {
      host: "127.0.0.1",
      port: 8545,
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/"+infura_apikey),
      network_id: 3,
      gas:4700000
    }
  }
};