const dayDreamContract = artifacts.require('DayDream');

module.exports = async (deployer, network) => {
  const projectName = 'DayDream Test 1';
  const projectSymbol = 'DT1';
  const initBaseURI = 'ipfs:// uri  /';

  await deployer.deploy(dayDreamContract, projectName, projectSymbol, initBaseURI);
};
