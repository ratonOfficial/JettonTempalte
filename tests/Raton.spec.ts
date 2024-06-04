import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { Raton } from '../wrappers/Raton';
import '@ton/test-utils';

describe('Raton', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let raton: SandboxContract<Raton>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        raton = blockchain.openContract(await Raton.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployResult = await raton.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: raton.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and raton are ready to use
    });
});
