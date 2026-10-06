import { providerRegistry } from '@aep/provider-registry';
import { GmCryptoProvider } from '@aep/crypto-gm-crypto';
import { NodeCryptoProvider } from '@aep/crypto-node';
await providerRegistry.register(new GmCryptoProvider());
await providerRegistry.register(new NodeCryptoProvider());
await import('@aep/mcp-server');
