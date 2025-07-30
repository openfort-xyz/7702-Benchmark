#!/usr/bin/env ts-node

import * as fs from 'fs';
import * as path from 'path';

// Type definitions
interface NetworkData {
  'Used Gas': number;
  weiCost: number;
  usd: string;
}

interface TestData {
  Direct?: {
    MAINNET: NetworkData;
    BASE: NetworkData;
    ARBITRUM: NetworkData;
    OPTIMISM: NetworkData;
  };
  Sponsored?: {
    MAINNET: NetworkData;
    BASE: NetworkData;
    ARBITRUM: NetworkData;
    OPTIMISM: NetworkData;
  };
}

interface BenchmarkFile {
  [categoryName: string]: {
    [testName: string]: TestData;
  };
}

interface ProcessedTest {
  testName: string;
  filename: string;
  category: string;
  hasDirectData: boolean;
  hasSponsoredData: boolean;
  directData?: TestData['Direct'];
  sponsoredData?: TestData['Sponsored'];
}

interface NetworkSpecificData {
  testName: string;
  category: string;
  type: 'Direct' | 'Sponsored';
  gasUsed: number;
  weiCost: number;
  usdCost: number;
  signatureMethod: string;
}

// Configuration
const BENCHMARK_DIR = './test/Output';
const NETWORKS: ('MAINNET' | 'BASE' | 'ARBITRUM' | 'OPTIMISM')[] = ['MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM'];

class NetworkSpecificBenchmarkGenerator {
  private benchmarks: Map<string, { data: BenchmarkFile; category: string }> = new Map();

  constructor() {
    this.loadBenchmarkFiles();
  }

  private loadBenchmarkFiles(): void {
    // Updated folder structure including the new Uniswap folder
    const folders = [
      { 
        folder: 'Deploy', 
        files: ['test_DeployOPFMain.json'] 
      },
      { 
        folder: 'Initialize', 
        files: [
          'test_InitializeTX.json',
          'test_InitializeTXWithRegisteringSessionKey.json',
          'test_InitializeTX_UOP.json',
          'test_InitializeTXWithRegisteringSessionKey_UOP.json'
        ] 
      },
      { 
        folder: 'Register-Key', 
        files: [
          'test_RegisterEOA.json',
          'test_RegisterP256.json',
          'test_RegisterP256NonExtrac.json',
          'test_RegisterEOA_UOP.json',
          'test_RegisterP256_UOP.json',
          'test_RegisterP256NonExtrac_UOP.json',
          'test_RegisterP256NonExtracWithMK_UOP.json'
        ] 
      },
      {
        folder: 'ERC20',
        files: [
          'test_ApproveErc20.json',
          'test_TransferErc20.json',
          'test_ApproveErc20_UOP.json',
          'test_TransferErc20_UOP.json',
          'test_ApproveErc20WithMK_UOP.json',
          'test_ApproveErc20WithP256_UOP.json',
          'test_TransferErc20WithMK_UOP.json',
          'test_TransferErc20WithP256_UOP.json'
        ]
      },
      {
        folder: 'NativeTransfer',
        files: [
          'test_SendETH.json',
          'test_SendETH_UOP.json',
          'test_SendETHP256_UOP.json',
          'test_SendETHWithMK_UOP.json',
          'test_SendETHWithSKEOA_UOP.json'
        ]
      },
      {
        folder: 'Batch',
        files: [
          'test_BatchExecution.json',
          'test_BatchExecution_UOP.json',
          'test_BatchExecutionWithMK_UOP.json',
          'test_BatchExecutionWithP256_UOP.json'
        ]
      },
      {
        folder: 'Uniswap',
        files: [
          'test_SwapETHForUSDC.json',
          'test_SwapETHForUSDC_UOP.json',
          'test_SwapETHForUSDCWithMK_UOP.json',
          'test_SwapETHForUSDCWithP256_UOP.json'
        ]
      }
    ];

    let loadedCount = 0;

    // First try to load from organized folder structure
    folders.forEach(({ folder, files }) => {
      files.forEach(filename => {
        const filePath = path.join(BENCHMARK_DIR, folder, filename);
        try {
          if (fs.existsSync(filePath)) {
            const content = fs.readFileSync(filePath, 'utf8');
            const data: BenchmarkFile = JSON.parse(content);
            this.benchmarks.set(filename, { data, category: folder });
            loadedCount++;
          }
        } catch (error) {
          console.error(`Error loading ${filePath}:`, (error as Error).message);
        }
      });
    });

    console.log(`Total loaded: ${loadedCount} benchmark files\n`);
  }

  private formatNumber(num: number): string {
    return new Intl.NumberFormat('en-US').format(num);
  }

  private formatWei(wei: number): string {
    const gwei = wei / 1e9;
    if (gwei >= 1e6) {
      return `${(gwei / 1e6).toFixed(2)}M Gwei`;
    } else if (gwei >= 1e3) {
      return `${(gwei / 1e3).toFixed(2)}K Gwei`;
    }
    return `${gwei.toFixed(2)} Gwei`;
  }

  private extractTestName(filename: string, fullTestName: string): string {
    const cleanName = fullTestName.replace('test_', '');
    
    const nameMap: { [key: string]: string } = {
      'DeployOPFMain': 'Deploy OPF',
      'InitializeTX': 'Initialize TX',
      'InitializeTX_UOP': 'Initialize TX (UOP)',
      'InitializeTXWithRegisteringSessionKey': 'Initialize + Session Key',
      'InitializeTXWithRegisteringSessionKey_UOP': 'Initialize + Session Key (UOP)',
      'RegisterEOA': 'Register EOA',
      'RegisterEOA_UOP': 'Register EOA (UOP)',
      'RegisterP256': 'Register P256',
      'RegisterP256_UOP': 'Register P256 (UOP)',
      'RegisterP256NonExtrac': 'Register P256 (Non-Extrac)',
      'RegisterP256NonExtrac_UOP': 'Register P256 (Non-Extrac UOP)',
      'RegisterP256NonExtracWithMK_UOP': 'Register P256 (Non-Extrac w/ MK UOP)',
      'ApproveErc20': 'Approve ERC20',
      'ApproveErc20_UOP': 'Approve ERC20 (UOP)',
      'ApproveErc20WithMK_UOP': 'Approve ERC20 w/ MK (UOP)',
      'ApproveErc20WithP256_UOP': 'Approve ERC20 w/ P256 (UOP)',
      'TransferErc20': 'Transfer ERC20',
      'TransferErc20_UOP': 'Transfer ERC20 (UOP)',
      'TransferErc20WithMK_UOP': 'Transfer ERC20 w/ MK (UOP)',
      'TransferErc20WithP256_UOP': 'Transfer ERC20 w/ P256 (UOP)',
      'SendETH': 'Send ETH',
      'SendETH_UOP': 'Send ETH (UOP)',
      'SendETHP256_UOP': 'Send ETH P256 (UOP)',
      'SendETHWithMK_UOP': 'Send ETH w/ MK (UOP)',
      'SendETHWithSKEOA_UOP': 'Send ETH w/ SK-EOA (UOP)',
      'BatchExecution': 'Batch Execution',
      'BatchExecution_UOP': 'Batch Execution (UOP)',
      'BatchExecutionWithMK_UOP': 'Batch Execution w/ MK (UOP)',
      'BatchExecutionWithP256_UOP': 'Batch Execution w/ P256 (UOP)',
      'SwapETHForUSDC': 'Swap ETH for USDC',
      'SwapETHForUSDC_UOP': 'Swap ETH for USDC (UOP)',
      'SwapETHForUSDCWithMK_UOP': 'Swap ETH for USDC w/ MK (UOP)',
      'SwapETHForUSDCWithP256_UOP': 'Swap ETH for USDC w/ P256 (UOP)'
    };

    return nameMap[cleanName] || cleanName.replace(/([A-Z])/g, ' $1').trim();
  }

  private extractSignatureMethod(testName: string): string {
    if (testName.includes('w/ MK')) return 'Master Key';
    if (testName.includes('w/ P256')) return 'P256 Signature';
    if (testName.includes('w/ SK-EOA')) return 'Session Key EOA';
    if (testName.includes('P256') && testName.includes('UOP')) return 'P256 Direct';
    if (testName.includes('(UOP)')) return 'Standard UOP';
    return 'Direct';
  }

  private processTestsForNetwork(network: 'MAINNET' | 'BASE' | 'ARBITRUM' | 'OPTIMISM'): NetworkSpecificData[] {
    const networkData: NetworkSpecificData[] = [];

    this.benchmarks.forEach((fileData, filename) => {
      const { data, category } = fileData;

      Object.keys(data).forEach(benchmarkCategory => {
        const testData = data[benchmarkCategory];
        
        Object.keys(testData).forEach(testName => {
          const cleanTestName = this.extractTestName(filename, testName);
          const test = testData[testName];
          const signatureMethod = this.extractSignatureMethod(cleanTestName);

          // Add Direct data if available
          if (test.Direct && test.Direct[network]) {
            const directData = test.Direct[network];
            networkData.push({
              testName: cleanTestName,
              category,
              type: 'Direct',
              gasUsed: directData['Used Gas'],
              weiCost: directData.weiCost,
              usdCost: parseFloat(directData.usd),
              signatureMethod: 'Direct'
            });
          }

          // Add Sponsored data if available
          if (test.Sponsored && test.Sponsored[network]) {
            const sponsoredData = test.Sponsored[network];
            networkData.push({
              testName: cleanTestName,
              category,
              type: 'Sponsored',
              gasUsed: sponsoredData['Used Gas'],
              weiCost: sponsoredData.weiCost,
              usdCost: parseFloat(sponsoredData.usd),
              signatureMethod
            });
          }
        });
      });
    });

    return networkData.sort((a, b) => a.category.localeCompare(b.category) || a.testName.localeCompare(b.testName));
  }

  private generateNetworkReport(network: 'MAINNET' | 'BASE' | 'ARBITRUM' | 'OPTIMISM'): string {
    const networkData = this.processTestsForNetwork(network);
    let output = '';

    // Header
    output += `# ${network} Network Benchmark Report\n\n`;
    output += `Generated: ${new Date().toLocaleString()}\n`;
    output += `Network: **${network}**\n\n`;

    // Network-specific insights
    output += this.generateNetworkInsights(network, networkData);

    // Overview table
    output += `## Complete Operations Overview\n\n`;
    output += this.generateOverviewTable(networkData);

    // Category-specific analysis
    output += this.generateCategoryAnalysis(networkData);

    // Signature method comparison
    output += this.generateSignatureMethodAnalysis(networkData);

    // Cost analysis
    output += this.generateCostAnalysis(network, networkData);

    // Gas efficiency analysis
    output += this.generateGasEfficiencyAnalysis(networkData);

    // Recommendations
    output += this.generateNetworkRecommendations(network, networkData);

    return output;
  }

  private generateNetworkInsights(network: string, data: NetworkSpecificData[]): string {
    let output = `## ${network} Network Insights\n\n`;

    const totalOperations = data.length;
    const directOperations = data.filter(d => d.type === 'Direct').length;
    const sponsoredOperations = data.filter(d => d.type === 'Sponsored').length;
    const totalCost = data.reduce((sum, d) => sum + d.usdCost, 0);
    const avgCost = totalCost / totalOperations;
    const totalGas = data.reduce((sum, d) => sum + d.gasUsed, 0);
    const avgGas = totalGas / totalOperations;

    const mostExpensive = data.reduce((max, d) => d.usdCost > max.usdCost ? d : max);
    const cheapest = data.reduce((min, d) => d.usdCost < min.usdCost ? d : min);
    const mostGasIntensive = data.reduce((max, d) => d.gasUsed > max.gasUsed ? d : max);
    const mostEfficient = data.reduce((min, d) => d.gasUsed < min.gasUsed ? d : min);

    output += `- **Total Operations**: ${totalOperations} (${directOperations} Direct, ${sponsoredOperations} Sponsored)\n`;
    output += `- **Total Cost**: ${totalCost.toFixed(4)}\n`;
    output += `- **Average Cost**: ${avgCost.toFixed(4)} per operation\n`;
    output += `- **Total Gas**: ${this.formatNumber(totalGas)} gas\n`;
    output += `- **Average Gas**: ${this.formatNumber(Math.round(avgGas))} gas per operation\n\n`;

    output += `### Performance Highlights\n`;
    output += `- **Most Expensive**: ${mostExpensive.testName} (${mostExpensive.type}) - ${mostExpensive.usdCost}\n`;
    output += `- **Cheapest**: ${cheapest.testName} (${cheapest.type}) - ${cheapest.usdCost}\n`;
    output += `- **Most Gas Intensive**: ${mostGasIntensive.testName} (${mostGasIntensive.type}) - ${this.formatNumber(mostGasIntensive.gasUsed)} gas\n`;
    output += `- **Most Efficient**: ${mostEfficient.testName} (${mostEfficient.type}) - ${this.formatNumber(mostEfficient.gasUsed)} gas\n\n`;

    return output;
  }

  private generateOverviewTable(data: NetworkSpecificData[]): string {
    let output = `| Operation | Category | Type | Signature Method | Gas Used | Wei Cost | USD Cost |\n`;
    output += `|-----------|----------|------|------------------|----------|----------|----------|\n`;

    data.forEach(item => {
      output += `| ${item.testName} | ${item.category} | ${item.type} | ${item.signatureMethod} | ${this.formatNumber(item.gasUsed)} | ${this.formatWei(item.weiCost)} | ${item.usdCost.toFixed(4)} |\n`;
    });

    output += '\n';
    return output;
  }

  private generateCategoryAnalysis(data: NetworkSpecificData[]): string {
    let output = `## Category Analysis\n\n`;

    const categories = [...new Set(data.map(d => d.category))];
    
    categories.forEach(category => {
      const categoryData = data.filter(d => d.category === category);
      const totalCost = categoryData.reduce((sum, d) => sum + d.usdCost, 0);
      const avgCost = totalCost / categoryData.length;
      const totalGas = categoryData.reduce((sum, d) => sum + d.gasUsed, 0);
      const avgGas = totalGas / categoryData.length;

      output += `### ${category}\n\n`;
      output += `- **Operations**: ${categoryData.length}\n`;
      output += `- **Total Cost**: ${totalCost.toFixed(4)}\n`;
      output += `- **Average Cost**: ${avgCost.toFixed(4)}\n`;
      output += `- **Total Gas**: ${this.formatNumber(totalGas)}\n`;
      output += `- **Average Gas**: ${this.formatNumber(Math.round(avgGas))}\n\n`;

      // Category table
      output += `| Operation | Type | Signature Method | Gas Used | USD Cost |\n`;
      output += `|-----------|------|------------------|----------|----------|\n`;
      
      categoryData.forEach(item => {
        output += `| ${item.testName} | ${item.type} | ${item.signatureMethod} | ${this.formatNumber(item.gasUsed)} | ${item.usdCost.toFixed(4)} |\n`;
      });

      output += '\n';
    });

    return output;
  }

  private generateSignatureMethodAnalysis(data: NetworkSpecificData[]): string {
    let output = `## Signature Method Analysis\n\n`;

    const methods = [...new Set(data.map(d => d.signatureMethod))];
    
    output += `| Signature Method | Operations | Avg Gas | Avg Cost | Total Cost |\n`;
    output += `|------------------|------------|---------|----------|------------|\n`;

    methods.forEach(method => {
      const methodData = data.filter(d => d.signatureMethod === method);
      const avgGas = methodData.reduce((sum, d) => sum + d.gasUsed, 0) / methodData.length;
      const avgCost = methodData.reduce((sum, d) => sum + d.usdCost, 0) / methodData.length;
      const totalCost = methodData.reduce((sum, d) => sum + d.usdCost, 0);

      output += `| ${method} | ${methodData.length} | ${this.formatNumber(Math.round(avgGas))} | ${avgCost.toFixed(4)} | ${totalCost.toFixed(4)} |\n`;
    });

    output += '\n';

    // Detailed signature method comparison
    const sponsoredMethods = methods.filter(m => m !== 'Direct');
    if (sponsoredMethods.length > 1) {
      output += `### Sponsored Transaction Methods Comparison\n\n`;
      
      sponsoredMethods.forEach(method => {
        const methodData = data.filter(d => d.signatureMethod === method);
        if (methodData.length > 0) {
          const avgGas = methodData.reduce((sum, d) => sum + d.gasUsed, 0) / methodData.length;
          const avgCost = methodData.reduce((sum, d) => sum + d.usdCost, 0) / methodData.length;
          
          output += `**${method}**:\n`;
          output += `- Average Gas: ${this.formatNumber(Math.round(avgGas))}\n`;
          output += `- Average Cost: ${avgCost.toFixed(4)}\n`;
          output += `- Operations: ${methodData.length}\n\n`;
        }
      });
    }

    return output;
  }

  private generateCostAnalysis(network: string, data: NetworkSpecificData[]): string {
    let output = `## Cost Analysis\n\n`;

    // Cost distribution
    const costRanges = [
      { min: 0, max: 0.001, label: 'Ultra Low (< $0.001)' },
      { min: 0.001, max: 0.01, label: 'Low ($0.001 - $0.01)' },
      { min: 0.01, max: 0.1, label: 'Medium ($0.01 - $0.1)' },
      { min: 0.1, max: 1, label: 'High ($0.1 - $1)' },
      { min: 1, max: Infinity, label: 'Very High (> $1)' }
    ];

    output += `### Cost Distribution\n\n`;
    output += `| Cost Range | Operations | Percentage |\n`;
    output += `|------------|------------|------------|\n`;

    costRanges.forEach(range => {
      const opsInRange = data.filter(d => d.usdCost >= range.min && d.usdCost < range.max);
      const percentage = (opsInRange.length / data.length * 100).toFixed(1);
      output += `| ${range.label} | ${opsInRange.length} | ${percentage}% |\n`;
    });

    output += '\n';

    // Direct vs Sponsored cost comparison
    const directOps = data.filter(d => d.type === 'Direct');
    const sponsoredOps = data.filter(d => d.type === 'Sponsored');

    if (directOps.length > 0 && sponsoredOps.length > 0) {
      const avgDirectCost = directOps.reduce((sum, d) => sum + d.usdCost, 0) / directOps.length;
      const avgSponsoredCost = sponsoredOps.reduce((sum, d) => sum + d.usdCost, 0) / sponsoredOps.length;
      const costMultiplier = avgSponsoredCost / avgDirectCost;

      output += `### Direct vs Sponsored Cost Impact\n\n`;
      output += `- **Average Direct Cost**: ${avgDirectCost.toFixed(4)}\n`;
      output += `- **Average Sponsored Cost**: ${avgSponsoredCost.toFixed(4)}\n`;
      output += `- **Cost Multiplier**: ${costMultiplier.toFixed(2)}x\n`;
      output += `- **Premium**: ${((costMultiplier - 1) * 100).toFixed(1)}% more expensive for sponsored transactions\n\n`;
    }

    return output;
  }

  private generateGasEfficiencyAnalysis(data: NetworkSpecificData[]): string {
    let output = `## Gas Efficiency Analysis\n\n`;

    // Gas usage ranges
    const gasRanges = [
      { min: 0, max: 50000, label: 'Very Efficient (< 50K gas)' },
      { min: 50000, max: 100000, label: 'Efficient (50K - 100K gas)' },
      { min: 100000, max: 500000, label: 'Moderate (100K - 500K gas)' },
      { min: 500000, max: 1000000, label: 'High (500K - 1M gas)' },
      { min: 1000000, max: Infinity, label: 'Very High (> 1M gas)' }
    ];

    output += `### Gas Usage Distribution\n\n`;
    output += `| Gas Range | Operations | Percentage |\n`;
    output += `|-----------|------------|------------|\n`;

    gasRanges.forEach(range => {
      const opsInRange = data.filter(d => d.gasUsed >= range.min && d.gasUsed < range.max);
      const percentage = (opsInRange.length / data.length * 100).toFixed(1);
      output += `| ${range.label} | ${opsInRange.length} | ${percentage}% |\n`;
    });

    output += '\n';

    // Gas efficiency by category
    const categories = [...new Set(data.map(d => d.category))];
    
    output += `### Gas Efficiency by Category\n\n`;
    output += `| Category | Avg Gas | Most Efficient | Least Efficient |\n`;
    output += `|----------|---------|----------------|------------------|\n`;

    categories.forEach(category => {
      const categoryData = data.filter(d => d.category === category);
      const avgGas = categoryData.reduce((sum, d) => sum + d.gasUsed, 0) / categoryData.length;
      const mostEfficient = categoryData.reduce((min, d) => d.gasUsed < min.gasUsed ? d : min);
      const leastEfficient = categoryData.reduce((max, d) => d.gasUsed > max.gasUsed ? d : max);

      output += `| ${category} | ${this.formatNumber(Math.round(avgGas))} | ${this.formatNumber(mostEfficient.gasUsed)} | ${this.formatNumber(leastEfficient.gasUsed)} |\n`;
    });

    output += '\n';

    return output;
  }

  private generateNetworkRecommendations(network: string, data: NetworkSpecificData[]): string {
    let output = `## ${network} Network Recommendations\n\n`;

    const totalCost = data.reduce((sum, d) => sum + d.usdCost, 0);
    const avgCost = totalCost / data.length;

    // Network-specific recommendations
    switch (network) {
      case 'MAINNET':
        output += `### Mainnet Considerations\n`;
        output += `- **High Cost Network**: Average operation costs ${avgCost.toFixed(4)}\n`;
        output += `- **Use for Production**: Only for final production deployments\n`;
        output += `- **Optimize Gas**: Every gas unit counts - optimize heavily before deploying\n`;
        output += `- **Batch Operations**: Consider batching multiple operations to reduce total costs\n`;
        output += `- **Monitor Gas Prices**: Deploy during low congestion periods\n\n`;
        break;

      case 'BASE':
        output += `### Base Network Considerations\n`;
        output += `- **Cost-Effective L2**: Average operation costs ${avgCost.toFixed(4)}\n`;
        output += `- **Good for Development**: Excellent cost-performance balance\n`;
        output += `- **Production Ready**: Suitable for production applications\n`;
        output += `- **Coinbase Ecosystem**: Leverage Coinbase integrations\n`;
        output += `- **Fast Finality**: Quick transaction confirmations\n\n`;
        break;

      case 'ARBITRUM':
        output += `### Arbitrum Network Considerations\n`;
        output += `- **Moderate Costs**: Average operation costs ${avgCost.toFixed(4)}\n`;
        output += `- **Ethereum Compatibility**: High EVM compatibility\n`;
        output += `- **Mature Ecosystem**: Well-established DeFi ecosystem\n`;
        output += `- **Good for Complex Apps**: Suitable for complex smart contracts\n`;
        output += `- **Established Infrastructure**: Robust tooling and support\n\n`;
        break;

      case 'OPTIMISM':
        output += `### Optimism Network Considerations\n`;
        output += `- **Lowest Cost**: Average operation costs ${avgCost.toFixed(4)}\n`;
        output += `- **Ideal for High-Volume**: Perfect for applications with many transactions\n`;
        output += `- **Development Environment**: Excellent for testing and development\n`;
        output += `- **Optimistic Rollup**: Understand the dispute resolution process\n`;
        output += `- **Cost Optimization**: Best choice for cost-sensitive applications\n\n`;
        break;
    }

    // Operation-specific recommendations
    const expensiveOps = data.filter(d => d.usdCost > avgCost * 2).sort((a, b) => b.usdCost - a.usdCost);
    const efficientOps = data.filter(d => d.usdCost < avgCost * 0.5).sort((a, b) => a.usdCost - b.usdCost);

    if (expensiveOps.length > 0) {
      output += `### High-Cost Operations to Monitor\n`;
      expensiveOps.slice(0, 5).forEach(op => {
        output += `- **${op.testName}** (${op.type}): ${op.usdCost.toFixed(4)} - Consider optimization\n`;
      });
      output += '\n';
    }

    if (efficientOps.length > 0) {
      output += `### Most Cost-Efficient Operations\n`;
      efficientOps.slice(0, 5).forEach(op => {
        output += `- **${op.testName}** (${op.type}): ${op.usdCost.toFixed(4)} - Great choice for high-frequency use\n`;
      });
      output += '\n';
    }

    // Signature method recommendations
    const sponsoredMethods = [...new Set(data.filter(d => d.type === 'Sponsored').map(d => d.signatureMethod))];
    if (sponsoredMethods.length > 1) {
      output += `### Signature Method Recommendations\n`;
      
      sponsoredMethods.forEach(method => {
        const methodData = data.filter(d => d.signatureMethod === method);
        const avgCost = methodData.reduce((sum, d) => sum + d.usdCost, 0) / methodData.length;
        const avgGas = methodData.reduce((sum, d) => sum + d.gasUsed, 0) / methodData.length;
        
        output += `- **${method}**: Avg ${avgCost.toFixed(4)}, ${this.formatNumber(Math.round(avgGas))} gas\n`;
      });
      output += '\n';
    }

    return output;
  }

  public generateAllNetworkReports(): void {
    console.log('Generating Network-Specific Benchmark Reports...\n');

    if (this.benchmarks.size === 0) {
      console.error('No benchmark files found!');
      return;
    }

    NETWORKS.forEach(network => {
      console.log(`Generating ${network} report...`);
      
      const report = this.generateNetworkReport(network);
      const outputPath = path.join(BENCHMARK_DIR, `${network.toLowerCase()}-benchmark-report.md`);
      
      try {
        fs.writeFileSync(outputPath, report, 'utf8');
        console.log(`${network} report saved to: ${outputPath}`);
      } catch (error) {
        console.error(`Error saving ${network} report:`, (error as Error).message);
      }
    });

    // Generate a summary comparison file
    this.generateNetworkComparisonReport();
    
    console.log('\nAll network-specific reports generated successfully!');
    console.log('\nGenerated files:');
    NETWORKS.forEach(network => {
      console.log(`   • ${network.toLowerCase()}-benchmark-report.md`);
    });
    console.log('   • networks-comparison-report.md');
  }

  private generateNetworkComparisonReport(): void {
    let output = '';

    output += `# Network Comparison Report\n\n`;
    output += `Generated: ${new Date().toLocaleString()}\n\n`;

    // Generate comparison data for all networks
    const networkComparisons: { [key: string]: NetworkSpecificData[] } = {};
    NETWORKS.forEach(network => {
      networkComparisons[network] = this.processTestsForNetwork(network);
    });

    // Overall network statistics
    output += `## Network Overview\n\n`;
    output += `| Network | Total Operations | Avg Cost | Total Cost | Avg Gas | Total Gas |\n`;
    output += `|---------|------------------|----------|------------|---------|----------|\n`;

    NETWORKS.forEach(network => {
      const data = networkComparisons[network];
      const totalOps = data.length;
      const avgCost = data.reduce((sum, d) => sum + d.usdCost, 0) / totalOps;
      const totalCost = data.reduce((sum, d) => sum + d.usdCost, 0);
      const avgGas = data.reduce((sum, d) => sum + d.gasUsed, 0) / totalOps;
      const totalGas = data.reduce((sum, d) => sum + d.gasUsed, 0);

      output += `| **${network}** | ${totalOps} | ${avgCost.toFixed(4)} | ${totalCost.toFixed(4)} | ${this.formatNumber(Math.round(avgGas))} | ${this.formatNumber(totalGas)} |\n`;
    });

    output += '\n';

    // Cost comparison analysis
    output += `## Cost Comparison Analysis\n\n`;
    
    const mainnetData = networkComparisons['MAINNET'];
    const baseData = networkComparisons['BASE'];
    const arbitrumData = networkComparisons['ARBITRUM'];
    const optimismData = networkComparisons['OPTIMISM'];

    const mainnetTotal = mainnetData.reduce((sum, d) => sum + d.usdCost, 0);
    const baseTotal = baseData.reduce((sum, d) => sum + d.usdCost, 0);
    const arbitrumTotal = arbitrumData.reduce((sum, d) => sum + d.usdCost, 0);
    const optimismTotal = optimismData.reduce((sum, d) => sum + d.usdCost, 0);

    output += `### Savings Analysis (vs MAINNET)\n\n`;
    output += `- **BASE**: ${((1 - baseTotal/mainnetTotal) * 100).toFixed(1)}% cheaper (Save ${(mainnetTotal - baseTotal).toFixed(4)})\n`;
    output += `- **ARBITRUM**: ${((1 - arbitrumTotal/mainnetTotal) * 100).toFixed(1)}% cheaper (Save ${(mainnetTotal - arbitrumTotal).toFixed(4)})\n`;
    output += `- **OPTIMISM**: ${((1 - optimismTotal/mainnetTotal) * 100).toFixed(1)}% cheaper (Save ${(mainnetTotal - optimismTotal).toFixed(4)})\n\n`;

    // Category comparison across networks
    output += `## Category Comparison Across Networks\n\n`;
    
    const categories = [...new Set(mainnetData.map(d => d.category))];
    
    categories.forEach(category => {
      output += `### ${category}\n\n`;
      output += `| Network | Operations | Avg Cost | Total Cost |\n`;
      output += `|---------|------------|----------|------------|\n`;

      NETWORKS.forEach(network => {
        const categoryData = networkComparisons[network].filter(d => d.category === category);
        const avgCost = categoryData.reduce((sum, d) => sum + d.usdCost, 0) / categoryData.length;
        const totalCost = categoryData.reduce((sum, d) => sum + d.usdCost, 0);

        output += `| **${network}** | ${categoryData.length} | ${avgCost.toFixed(4)} | ${totalCost.toFixed(4)} |\n`;
      });

      output += '\n';
    });

    // Operation-specific comparison (most expensive operations)
    output += `## Most Expensive Operations Comparison\n\n`;
    
    // Find the most expensive operations on MAINNET and compare across networks
    const expensiveMainnetOps = mainnetData
      .sort((a, b) => b.usdCost - a.usdCost)
      .slice(0, 10);

    expensiveMainnetOps.forEach(mainnetOp => {
      const opName = mainnetOp.testName;
      const opType = mainnetOp.type;
      
      output += `### ${opName} (${opType})\n\n`;
      output += `| Network | Cost | Gas Used | Wei Cost |\n`;
      output += `|---------|------|----------|----------|\n`;

      NETWORKS.forEach(network => {
        const networkOp = networkComparisons[network].find(d => 
          d.testName === opName && d.type === opType
        );
        
        if (networkOp) {
          output += `| **${network}** | ${networkOp.usdCost.toFixed(4)} | ${this.formatNumber(networkOp.gasUsed)} | ${this.formatWei(networkOp.weiCost)} |\n`;
        } else {
          output += `| **${network}** | N/A | N/A | N/A |\n`;
        }
      });

      output += '\n';
    });

    // Signature method comparison across networks
    output += `## Signature Method Performance Across Networks\n\n`;
    
    const allMethods = [...new Set(
      Object.values(networkComparisons)
        .flat()
        .map(d => d.signatureMethod)
    )];

    allMethods.forEach(method => {
      output += `### ${method}\n\n`;
      output += `| Network | Operations | Avg Cost | Avg Gas |\n`;
      output += `|---------|------------|----------|----------|\n`;

      NETWORKS.forEach(network => {
        const methodData = networkComparisons[network].filter(d => d.signatureMethod === method);
        
        if (methodData.length > 0) {
          const avgCost = methodData.reduce((sum, d) => sum + d.usdCost, 0) / methodData.length;
          const avgGas = methodData.reduce((sum, d) => sum + d.gasUsed, 0) / methodData.length;
          
          output += `| **${network}** | ${methodData.length} | ${avgCost.toFixed(4)} | ${this.formatNumber(Math.round(avgGas))} |\n`;
        } else {
          output += `| **${network}** | 0 | N/A | N/A |\n`;
        }
      });

      output += '\n';
    });

    // Network recommendations
    output += `## Network Selection Recommendations\n\n`;

    output += `### Use Case Recommendations\n\n`;
    output += `**Production Applications**\n`;
    output += `- **High-Value Transactions**: MAINNET (maximum security)\n`;
    output += `- **General Production**: BASE (good balance of cost and features)\n`;
    output += `- **Cost-Sensitive Apps**: OPTIMISM (lowest costs)\n\n`;

    output += `**Development & Testing**\n`;
    output += `- **Primary Development**: OPTIMISM (ultra-low costs)\n`;
    output += `- **Pre-Production Testing**: BASE (production-like environment)\n`;
    output += `- **Final Validation**: ARBITRUM (mature ecosystem)\n\n`;

    output += `**Transaction Volume Considerations**\n`;
    output += `- **Low Volume (<100 tx/day)**: Any network suitable\n`;
    output += `- **Medium Volume (100-1000 tx/day)**: BASE or ARBITRUM recommended\n`;
    output += `- **High Volume (1000+ tx/day)**: OPTIMISM strongly recommended\n\n`;

    output += `### Network Rankings by Category\n\n`;

    categories.forEach(category => {
      const categoryRankings = NETWORKS.map(network => {
        const categoryData = networkComparisons[network].filter(d => d.category === category);
        const avgCost = categoryData.reduce((sum, d) => sum + d.usdCost, 0) / categoryData.length;
        return { network, avgCost };
      }).sort((a, b) => a.avgCost - b.avgCost);

      output += `**${category} (by cost)**:\n`;
      categoryRankings.forEach((ranking, index) => {
        const position = index === 0 ? '1st' : index === 1 ? '2nd' : index === 2 ? '3rd' : `${index + 1}th`;
        output += `${index + 1}. ${ranking.network} - ${ranking.avgCost.toFixed(4)}\n`;
      });
      output += '\n';
    });

    // Save the comparison report
    const outputPath = path.join(BENCHMARK_DIR, 'networks-comparison-report.md');
    try {
      fs.writeFileSync(outputPath, output, 'utf8');
      console.log(`Network comparison report saved to: ${outputPath}`);
    } catch (error) {
      console.error('Error saving network comparison report:', (error as Error).message);
    }
  }

  public run(): void {
    console.log('Starting Network-Specific Benchmark Generation...\n');
    
    // Show what files were loaded
    console.log('Loaded benchmark files:');
    this.benchmarks.forEach((fileData, filename) => {
      const testCount = Object.keys(fileData.data).reduce((count, category) => {
        return count + Object.keys(fileData.data[category]).length;
      }, 0);
      console.log(`   • ${filename} (${fileData.category}) - ${testCount} test(s)`);
    });
    console.log('');
    
    this.generateAllNetworkReports();
  }
}

// Main execution
function main(): void {
  const generator = new NetworkSpecificBenchmarkGenerator();
  generator.run();
}

// Export for potential imports
export { NetworkSpecificBenchmarkGenerator, NetworkSpecificData };

// Run if executed directly
if (require.main === module) {
  main();
}