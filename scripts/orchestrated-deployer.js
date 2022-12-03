const main = async () => {
  var rContractFactory = await hre.ethers.getContractFactory('RentedKey')
  var contract = await rContractFactory.deploy(0, 0, 'RTemp', 'RT')
  await contract.deployed()
  var rentedKeyTemplate = contract.address

  var sContractFactory = await hre.ethers.getContractFactory('SoulBoundKey')
  var SBTcontract = await sContractFactory.deploy(0, 0, 'STemp', 'ST')
  await SBTcontract.deployed()
  var SBKtemplate = SBTcontract.address

  var gContractFactory = await hre.ethers.getContractFactory('Gatekeeper')
  var gatekeeperContract = await gContractFactory.deploy()
  await gatekeeperContract.deployed()
  var gatekeeper = gatekeeperContract.address

  gatekeeper.setTemplates(SBKtemplate, rentedKeyTemplate)
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()
