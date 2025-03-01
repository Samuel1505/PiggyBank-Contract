import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("PiggyBankModule", (m) => {
  // Deploy the PiggyBankFactory
  const piggyBankFactory = m.contract("PiggyBankFactory");

  // Parameters for PiggyBank
  const owner = m.getAccount(0); // Use the first account from Hardhat's list
  const purpose = "Vacation Fund";
  const duration = 24 * 60 * 60; // 1 day in seconds

  // Deploy a PiggyBank instance directly (for testing standalone deployment)
  const piggyBank = m.contract("PiggyBank", [owner, purpose, duration]);

  // Alternatively, use the factory to deploy a PiggyBank (commented out for now)
  // const piggyBankTx = m.call(piggyBankFactory, "createPiggyBank", [purpose, duration], {
  //   from: owner,
  // });

  return {
    piggyBankFactory,
    piggyBank,
  };
});