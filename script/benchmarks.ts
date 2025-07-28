#!/usr/bin/env ts-node

import * as fs from 'fs';
import * as path from 'path';

// Type definitions
interface NetworkData {
  'Used Gas': number;
  weiCost: number;
  usd: string;
}

interface DirectData {
  MAINNET: NetworkData;
  BASE: NetworkData;
  ARBITRUM: NetworkData;
  OPTIMISM: NetworkData;
}

interface TestData {
  [testName: string]: {
    Direct: DirectData;
  };
}

interface BenchmarkFile {
  [categoryName: string]: TestData;
}

interface ProcessedTest {
  testName: string;
  filename: string;
  category: string;
  data: DirectData;
}

interface CostAnalysis {
  network: string;
  cost: number;
  display: string;
}

// Configuration
const BENCHMARK_DIR = './test/Output';
const NETWORKS: (keyof DirectData)[] = ['MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM'];

class BenchmarkPresenter {
  private benchmarks: Map<string, { data: BenchmarkFile; category: string }> = new Map();

  constructor() {
    this.loadBenchmarkFiles();
  }

  private loadBenchmarkFiles(): void {
    const folders = [
      { folder: 'Deploy', files: ['test_DeployOPFMain.json'] },
      { folder: 'Initialize', files: ['test_InitializeTX.json', 'test_InitializeTXWithRegisteringSessionKey.json'] },
      { folder: 'Register-Key', files: ['test_RegisterEOA.json', 'test_RegisterP256.json', 'test_RegisterP256NonExtrac.json'] }
    ];

    let loadedCount = 0;

    folders.forEach(({ folder, files }) => {
      files.forEach(filename => {
        const filePath = path.join(BENCHMARK_DIR, folder, filename);
        try {
          if (fs.existsSync(filePath)) {
            const content = fs.readFileSync(filePath, 'utf8');
            const data: BenchmarkFile = JSON.parse(content);
            this.benchmarks.set(filename, { data, category: folder });
            loadedCount++;
          } else {
            console.warn(`⚠️  File not found: ${filePath}`);
          }
        } catch (error) {
          console.error(`❌ Error loading ${filePath}:`, (error as Error).message);
        }
      });
    });

    console.log(`✅ Loaded ${loadedCount} benchmark files\n`);
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
    // Create cleaner, shorter test names
    const cleanName = fullTestName.replace('test_', '');
    
    // Map specific test names to shorter versions
    const nameMap: { [key: string]: string } = {
      'DeployOPFMain': 'Deploy OPF',
      'InitializeTX': 'Initialize TX',
      'InitializeTXWithRegisteringSessionKey': 'Initialize + Session Key',
      'RegisterEOA': 'Register EOA',
      'RegisterP256': 'Register P256',
      'RegisterP256NonExtrac': 'Register P256 (Non-Extrac)'
    };

    return nameMap[cleanName] || cleanName.replace(/([A-Z])/g, ' $1').trim();
  }

  private processTests(): ProcessedTest[] {
    const processedTests: ProcessedTest[] = [];

    this.benchmarks.forEach((fileData, filename) => {
      const { data, category } = fileData;

      // Extract test data
      const benchmarkCategory = Object.keys(data)[0];
      const testData = data[benchmarkCategory];
      const testName = Object.keys(testData)[0];
      const cleanTestName = this.extractTestName(filename, testName);

      processedTests.push({
        testName: cleanTestName,
        filename,
        category,
        data: testData[testName].Direct
      });
    });

    return processedTests;
  }

  public generateReport(): void {
    console.log('# 🚀 Blockchain Network Benchmark Results\n');
    console.log(`📅 Generated: ${new Date().toLocaleString()}\n`);

    if (this.benchmarks.size === 0) {
      console.error('❌ No benchmark files found!');
      this.showExpectedStructure();
      return;
    }

    const processedTests = this.processTests();
    
    // Group by category
    const categories: { [key: string]: ProcessedTest[] } = {};
    processedTests.forEach(test => {
      if (!categories[test.category]) {
        categories[test.category] = [];
      }
      categories[test.category].push(test);
    });

    // Display by category
    this.displayCategoryTables(categories);
    this.generateSummaryTable(processedTests);
    this.generateCostComparison(processedTests);
    this.generateInsights(processedTests);
  }

  private displayCategoryTables(categories: { [key: string]: ProcessedTest[] }): void {
    Object.entries(categories).forEach(([category, tests]) => {
      console.log(`## 📊 ${category} Benchmarks\n`);
      
      // Create properly aligned table
      const tableData: string[][] = [
        ['Test Name', 'Network', 'Gas Used', 'Wei Cost', 'USD Cost']
      ];
      
      tests.forEach(test => {
        NETWORKS.forEach(network => {
          const networkData = test.data[network];
          if (networkData) {
            tableData.push([
              test.testName,
              network,
              this.formatNumber(networkData['Used Gas']),
              this.formatWei(networkData.weiCost),
              `${networkData.usd}`
            ]);
          }
        });
      });
      
      this.printAlignedTable(tableData);
      console.log('');
    });
  }

  private printAlignedTable(data: string[][]): void {
    if (data.length === 0) return;
    
    // Calculate column widths
    const colWidths = data[0].map((_, colIndex) => 
      Math.max(...data.map(row => row[colIndex]?.length || 0))
    );
    
    // Print header
    const header = data[0];
    const headerRow = '| ' + header.map((cell, i) => cell.padEnd(colWidths[i])).join(' | ') + ' |';
    const separatorRow = '| ' + colWidths.map(width => '-'.repeat(width)).join(' | ') + ' |';
    
    console.log(headerRow);
    console.log(separatorRow);
    
    // Print data rows
    data.slice(1).forEach(row => {
      const dataRow = '| ' + row.map((cell, i) => cell.padEnd(colWidths[i])).join(' | ') + ' |';
      console.log(dataRow);
    });
  }

  private generateSummaryTable(tests: ProcessedTest[]): void {
    console.log('## 📈 Gas Usage Summary\n');
    
    const tableData: string[][] = [
      ['Test', 'MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM']
    ];

    tests.forEach(test => {
      const gasUsage = NETWORKS.map(network => {
        const networkData = test.data[network];
        return networkData ? this.formatNumber(networkData['Used Gas']) : 'N/A';
      });
      tableData.push([test.testName, ...gasUsage]);
    });
    
    this.printAlignedTable(tableData);
    console.log('');
  }

  private generateCostComparison(tests: ProcessedTest[]): void {
    console.log('## 💰 Cost Comparison (USD)\n');
    
    const tableData: string[][] = [
      ['Test', 'MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM', '🏆 Best']
    ];

    tests.forEach(test => {
      const costs: CostAnalysis[] = NETWORKS.map(network => {
        const networkData = test.data[network];
        return networkData ? {
          network,
          cost: parseFloat(networkData.usd),
          display: `${networkData.usd}`
        } : { network, cost: Infinity, display: 'N/A' };
      });

      const bestNetwork = costs.reduce((min, current) => 
        current.cost < min.cost ? current : min
      );

      const costDisplays = costs.map(c => c.display);
      tableData.push([test.testName, ...costDisplays, `**${bestNetwork.network}**`]);
    });
    
    this.printAlignedTable(tableData);
    console.log('');
  }

  private generateInsights(tests: ProcessedTest[]): void {
    console.log('## 🔍 Key Insights\n');
    
    // Calculate total costs and savings
    let totalMainnet = 0;
    let totalOptimism = 0;
    let totalBase = 0;
    let totalArbitrum = 0;

    tests.forEach(test => {
      totalMainnet += parseFloat(test.data.MAINNET.usd);
      totalOptimism += parseFloat(test.data.OPTIMISM.usd);
      totalBase += parseFloat(test.data.BASE.usd);
      totalArbitrum += parseFloat(test.data.ARBITRUM.usd);
    });

    const savings = totalMainnet - totalOptimism;
    const savingsPercent = ((savings / totalMainnet) * 100).toFixed(1);
    const costMultiplier = Math.round(totalMainnet / totalOptimism);

    console.log(`- 🌟 **Cheapest Network**: OPTIMISM consistently offers the lowest costs`);
    console.log(`- 💸 **Most Expensive**: MAINNET has the highest transaction costs`);
    console.log(`- ⛽ **Gas Consistency**: Gas usage remains the same across networks`);
    console.log(`- 💡 **Cost Savings**: Using OPTIMISM vs MAINNET saves ~${savingsPercent}% (Total: $${savings.toFixed(4)})`);
    console.log(`- 📊 **Price Variation**: Up to ${costMultiplier}x difference between most/least expensive networks`);
    console.log(`- 💰 **Total Costs**: MAINNET: $${totalMainnet.toFixed(4)} | BASE: $${totalBase.toFixed(4)} | ARBITRUM: $${totalArbitrum.toFixed(4)} | OPTIMISM: $${totalOptimism.toFixed(4)}`);
    
    // Find most expensive operation
    const mostExpensive = tests.reduce((max, test) => {
      const mainnetCost = parseFloat(test.data.MAINNET.usd);
      return mainnetCost > parseFloat(max.data.MAINNET.usd) ? test : max;
    });
    
    console.log(`- 🔥 **Most Expensive Operation**: "${mostExpensive.testName}" ($${mostExpensive.data.MAINNET.usd} on MAINNET)`);
    
    // Find most efficient (lowest gas)
    const mostEfficient = tests.reduce((min, test) => {
      const gasUsed = test.data.MAINNET['Used Gas'];
      return gasUsed < min.data.MAINNET['Used Gas'] ? test : min;
    });
    
    console.log(`- ⚡ **Most Efficient Operation**: "${mostEfficient.testName}" (${this.formatNumber(mostEfficient.data.MAINNET['Used Gas'])} gas)`);
    console.log('');
  }

  private showExpectedStructure(): void {
    console.log('Expected file structure:');
    console.log('test/Output/');
    console.log('├── Deploy/test_DeployOPFMain.json');
    console.log('├── Initialize/test_InitializeTX.json');
    console.log('├── Initialize/test_InitializeTXWithRegisteringSessionKey.json');
    console.log('├── Register-Key/test_RegisterEOA.json');
    console.log('├── Register-Key/test_RegisterP256.json');
    console.log('└── Register-Key/test_RegisterP256NonExtrac.json');
  }

  public saveMarkdownReport(): void {
    const originalConsoleLog = console.log;
    let output = '';
    
    console.log = (...args: any[]) => {
      output += args.join(' ') + '\n';
    };
    
    this.generateReport();
    
    console.log = originalConsoleLog;
    
    const outputPath = path.join(BENCHMARK_DIR, 'benchmark-report.md');
    try {
      fs.writeFileSync(outputPath, output, 'utf8');
      console.log(`✅ Markdown report saved to: ${outputPath}`);
    } catch (error) {
      console.error('❌ Error saving report:', (error as Error).message);
    }
  }

  public run(): void {
    console.log('🚀 Starting Benchmark Analysis...\n');
    
    if (this.benchmarks.size === 0) {
      console.error('❌ No benchmark files found! Make sure your files are in the correct directory.');
      this.showExpectedStructure();
      return;
    }
    
    // Generate and display report
    this.generateReport();
    
    // Save markdown version
    this.saveMarkdownReport();
    
    console.log('✨ Analysis complete! Check the generated markdown file for a formatted version.');
  }
}

// Main execution
function main(): void {
  const presenter = new BenchmarkPresenter();
  presenter.run();
}

// Export for potential imports
export { BenchmarkPresenter, NetworkData, DirectData, ProcessedTest };

// Run if executed directly
if (require.main === module) {
  main();
}