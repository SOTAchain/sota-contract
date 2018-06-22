// var ConvertLib = artifacts.require("./ConvertLib.sol");
var SotaToken = artifacts.require("./SotaToken.sol");

module.exports = function(deployer) {
  // deployer.deploy(SafeMath);
  // deployer.deploy(ERC20);
  // deployer.link(SafeMath, SotaToken);
  // deployer.link(ERC20, SotaToken);
  deployer.deploy(SotaToken);
};
