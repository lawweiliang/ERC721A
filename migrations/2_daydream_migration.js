const dayDreamContract = artifacts.require('DayDream');

module.exports = async (deployer, network) => {
  const projectName = 'Daydream Test 1';
  const projectSymbol = 'DT1';
  const initBaseURI = 'ipfs:// uri  /';

  await deployer.deploy(dayDreamContract, 'DayDream', 'DD', '');
};
