const main = async () => {
  console.log('Deploying starts')
  var rContractFactory = await hre.ethers.getContractFactory('RentedKey')
  //   var contract = await rContractFactory.deploy(0, 0, 'RTemp', 'RT')
  //   await contract.deployed()
  var rentedKeyTemplate = '0x77c88672C7328876dA6aa70f3d4330068d9731d9'
  console.log('RentedKey Address', rentedKeyTemplate)

  var sContractFactory = await hre.ethers.getContractFactory('SoulBoundKey')
  //   var SBTcontract = await sContractFactory.deploy(0, 0, 'STemp', 'ST')
  //   await SBTcontract.deployed()
  var SBKtemplate = '0xAEB5339020C6BFB5D4E785346b632b418d368C63'
  console.log('SBT Address', SBKtemplate)

  var gContractFactory = await hre.ethers.getContractFactory('Gatekeeper')
  //   var gatekeeperContract = await gContractFactory.deploy()
  //   await gatekeeperContract.deployed()
  var gatekeeperContract = await gContractFactory.attach(
    '0xCAb5B4e33Db07F345b8C10931Dd45ed519A61D3C',
  )
  var gatekeeper = gatekeeperContract.address
  console.log('GK Address', gatekeeper)

  gatekeeperContract.setTemplates(SBKtemplate, rentedKeyTemplate)
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
