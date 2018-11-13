var MicrolendingPlatform = artifacts.require("./MicrolendingPlatform.sol")

module.exports = function(deployer) {
	deployer.deploy(MicrolendingPlatform);
}
