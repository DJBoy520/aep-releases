async function main() {
  const { createStandaloneServer } = await import('@aep/mcp-server');
  const { StdioServerTransport } = await import('@modelcontextprotocol/sdk/server/stdio.js');
  const { server } = createStandaloneServer('dual', { offline: false });
  await server.connect(new StdioServerTransport());
}
main().catch((err) => { console.error('Fatal AEP MCP error:', err); process.exit(1); });
