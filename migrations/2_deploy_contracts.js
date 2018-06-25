// var ConvertLib = artifacts.require("./ConvertLib.sol");
var SotaToken = artifacts.require("./SotaToken.sol");

module.exports = function(deployer) {
  deployer.deploy(SotaToken);
};
