const dayDreamContract = artifacts.require('DayDream');

module.exports = async (deployer, network) => {
  await deployer.deploy(dayDreamContract, 'DayDream', 'DD');
};
