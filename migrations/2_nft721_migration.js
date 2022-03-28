const nft721Royalty = artifacts.require('NFT721Royalty');

module.exports = async (deployer, network) => {
  await deployer.deploy(nft721Royalty);
};
