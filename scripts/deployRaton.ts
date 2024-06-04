import { toNano } from '@ton/core';
import { Raton } from '../wrappers/Raton';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const raton = provider.open(await Raton.fromInit());

    await raton.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(raton.address);

    // run methods on `raton`
}
