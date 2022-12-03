const main = async () => {
    const contractFactory = await hre.ethers.getContractFactory("DystopiaLens");
    const contract = await contractFactory.deploy();
    await contract.deployed();
    const 
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();
  