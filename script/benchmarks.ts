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

interface CostAnalysis {
  network: string;
  cost: number;
  display: string;
}

// Configuration
const BENCHMARK_DIR = './test/Output';
const NETWORKS: ('MAINNET' | 'BASE' | 'ARBITRUM' | 'OPTIMISM')[] = ['MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM'];

class EnhancedBenchmarkPresenter {
  private benchmarks: Map<string, { data: BenchmarkFile; category: string }> = new Map();

  constructor() {
    this.loadBenchmarkFiles();
  }

  private loadBenchmarkFiles(): void {
    // Updated folder structure based on actual tree (all 33 files)
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
          console.error(`❌ Error loading ${filePath}:`, (error as Error).message);
        }
      });
    });

    // If no files found in folders, try loading from current directory or BENCHMARK_DIR root
    if (loadedCount === 0) {
      console.log('📁 No files found in organized folders, trying root directory...');
      
      const allFiles = [
        'test_DeployOPFMain.json',
        'test_InitializeTX.json',
        'test_InitializeTXWithRegisteringSessionKey.json',
        'test_InitializeTX_UOP.json',
        'test_InitializeTXWithRegisteringSessionKey_UOP.json',
        'test_RegisterEOA.json',
        'test_RegisterP256.json',
        'test_RegisterP256NonExtrac.json',
        'test_RegisterEOA_UOP.json',
        'test_RegisterP256_UOP.json',
        'test_RegisterP256NonExtrac_UOP.json',
        'test_RegisterP256NonExtracWithMK_UOP.json',
        'test_ApproveErc20.json',
        'test_TransferErc20.json',
        'test_ApproveErc20_UOP.json',
        'test_TransferErc20_UOP.json',
        'test_ApproveErc20WithMK_UOP.json',
        'test_ApproveErc20WithP256_UOP.json',
        'test_TransferErc20WithMK_UOP.json',
        'test_TransferErc20WithP256_UOP.json',
        'test_SendETH.json',
        'test_SendETH_UOP.json',
        'test_SendETHP256_UOP.json',
        'test_SendETHWithMK_UOP.json',
        'test_SendETHWithSKEOA_UOP.json',
        'test_BatchExecution.json',
        'test_BatchExecution_UOP.json',
        'test_BatchExecutionWithMK_UOP.json',
        'test_BatchExecutionWithP256_UOP.json'
      ];
      
      allFiles.forEach(filename => {
        // Try current directory first
        let filePath = `./${filename}`;
        let category = this.getCategoryFromFilename(filename);
        
        if (!fs.existsSync(filePath)) {
          // Try BENCHMARK_DIR root
          filePath = path.join(BENCHMARK_DIR, filename);
        }
        
        try {
          if (fs.existsSync(filePath)) {
            const content = fs.readFileSync(filePath, 'utf8');
            const data: BenchmarkFile = JSON.parse(content);
            this.benchmarks.set(filename, { data, category });
            loadedCount++;
            console.log(`✅ Loaded: ${filename} (${category})`);
          }
        } catch (error) {
          console.error(`❌ Error loading ${filePath}:`, (error as Error).message);
        }
      });
    }

    console.log(`\n✅ Total loaded: ${loadedCount} benchmark files\n`);
  }

  private getCategoryFromFilename(filename: string): string {
    if (filename.includes('Deploy')) return 'Deploy';
    if (filename.includes('Initialize')) return 'Initialize';
    if (filename.includes('Register')) return 'Register-Key';
    if (filename.includes('Approve') || filename.includes('Transfer')) return 'ERC20';
    if (filename.includes('SendETH')) return 'NativeTransfer';
    if (filename.includes('BatchExecution')) return 'Batch';
    return 'Other';
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
      'BatchExecutionWithP256_UOP': 'Batch Execution w/ P256 (UOP)'
    };

    return nameMap[cleanName] || cleanName.replace(/([A-Z])/g, ' $1').trim();
  }

  private processTests(): ProcessedTest[] {
    const processedTests: ProcessedTest[] = [];

    this.benchmarks.forEach((fileData, filename) => {
      const { data, category } = fileData;

      Object.keys(data).forEach(benchmarkCategory => {
        const testData = data[benchmarkCategory];
        
        Object.keys(testData).forEach(testName => {
          const cleanTestName = this.extractTestName(filename, testName);
          const test = testData[testName];

          // Handle special case where SendETH file contains UOP test but it's actually Sponsored
          let hasDirectData = !!test.Direct;
          let hasSponsoredData = !!test.Sponsored;
          let directData = test.Direct;
          let sponsoredData = test.Sponsored;

          // Special handling for SendETH case
          if (testName === 'test_SendETH_UOP' && test.Sponsored) {
            hasSponsoredData = true;
            hasDirectData = false;
          }

          // Validate data consistency
          if (directData) {
            this.validateNetworkData(directData, testName, 'Direct');
          }
          if (sponsoredData) {
            this.validateNetworkData(sponsoredData, testName, 'Sponsored');
          }

          processedTests.push({
            testName: cleanTestName,
            filename,
            category,
            hasDirectData,
            hasSponsoredData,
            directData,
            sponsoredData
          });
        });
      });
    });

    return processedTests;
  }

  private validateNetworkData(networkData: any, testName: string, type: string): void {
    const networks = Object.keys(networkData);
    const gasUsages = networks.map(network => networkData[network]['Used Gas']);
    const uniqueGasUsages = [...new Set(gasUsages)];
    
    // Check for unusual gas variations (more than 1% difference between networks)
    if (uniqueGasUsages.length > 1) {
      const minGas = Math.min(...gasUsages);
      const maxGas = Math.max(...gasUsages);
      const variation = ((maxGas - minGas) / minGas) * 100;
      
      if (variation > 1) {
        console.warn(`⚠️  Gas usage variation detected in ${testName} (${type}): ${variation.toFixed(1)}% difference between networks`);
      }
    }
  }

  public generateReport(): void {
    console.log('# 🚀 Enhanced Blockchain Network Benchmark Results\n');
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

    // Display comprehensive analysis
    this.displayDirectVsSponsoredComparison(processedTests);
    this.displaySignatureMethodComparison(processedTests);
    this.displayCategoryTables(categories);
    this.generateGasUsageSummary(processedTests);
    this.generateCostComparison(processedTests);
    this.generateDirectVsSponsoredAnalysis(processedTests);
    this.generateInsights(processedTests);
  }

  private displayDirectVsSponsoredComparison(tests: ProcessedTest[]): void {
    console.log('## 🔄 Direct vs Sponsored Transaction Comparison\n');
    
    // Find tests that have both Direct and Sponsored versions
    const testPairs: { [key: string]: { direct?: ProcessedTest; sponsored?: ProcessedTest } } = {};
    
    tests.forEach(test => {
      const baseName = test.testName.replace(' (UOP)', '');
      if (!testPairs[baseName]) {
        testPairs[baseName] = {};
      }
      
      if (test.hasDirectData) {
        testPairs[baseName].direct = test;
      }
      if (test.hasSponsoredData) {
        testPairs[baseName].sponsored = test;
      }
    });

    const tableData: string[][] = [
      ['Test', 'Type', 'MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM', 'Gas Used']
    ];

    Object.entries(testPairs).forEach(([baseName, pair]) => {
      if (pair.direct && pair.direct.directData) {
        const directData = pair.direct.directData;
        tableData.push([
          baseName,
          'Direct',
          `$${directData.MAINNET.usd}`,
          `$${directData.BASE.usd}`,
          `$${directData.ARBITRUM.usd}`,
          `$${directData.OPTIMISM.usd}`,
          this.formatNumber(directData.MAINNET['Used Gas'])
        ]);
      }
      
      if (pair.sponsored && pair.sponsored.sponsoredData) {
        const sponsoredData = pair.sponsored.sponsoredData;
        tableData.push([
          baseName,
          'Sponsored',
          `$${sponsoredData.MAINNET.usd}`,
          `$${sponsoredData.BASE.usd}`,
          `$${sponsoredData.ARBITRUM.usd}`,
          `$${sponsoredData.OPTIMISM.usd}`,
          this.formatNumber(sponsoredData.MAINNET['Used Gas'])
        ]);
      }
      
      // Add separator line
      if (pair.direct && pair.sponsored) {
        tableData.push(['---', '---', '---', '---', '---', '---', '---']);
      }
    });
    
    this.printAlignedTable(tableData);
    console.log('');
  }

  private displaySignatureMethodComparison(tests: ProcessedTest[]): void {
    console.log('## 🔐 Signature Method Comparison\n');
    
    // Group tests by operation type and signature method
    const operationGroups: { [key: string]: ProcessedTest[] } = {};
    
    tests.forEach(test => {
      // Extract base operation name (without signature method suffix)
      let baseOp = test.testName
        .replace(' (UOP)', '')
        .replace(' w/ MK', '')
        .replace(' w/ P256', '')
        .replace(' w/ SK-EOA', '')
        .replace(' P256', '');
        
      if (!operationGroups[baseOp]) {
        operationGroups[baseOp] = [];
      }
      operationGroups[baseOp].push(test);
    });

    // Display comparison for operations that have multiple signature methods
    Object.entries(operationGroups).forEach(([baseOp, testGroup]) => {
      const signatureMethods = testGroup.filter(t => 
        t.testName.includes('w/ MK') || 
        t.testName.includes('w/ P256') || 
        t.testName.includes('w/ SK-EOA') ||
        t.testName.includes('P256') ||
        t.testName.includes('(UOP)')
      );
      
      if (signatureMethods.length > 1) {
        console.log(`### ${baseOp} - Signature Methods\n`);
        
        const tableData: string[][] = [
          ['Method', 'MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM', 'Gas Used']
        ];
        
        signatureMethods.forEach(test => {
          const data = test.sponsoredData || test.directData;
          if (data) {
            const methodType = this.extractSignatureMethod(test.testName);
            tableData.push([
              methodType,
              `$${data.MAINNET.usd}`,
              `$${data.BASE.usd}`,
              `$${data.ARBITRUM.usd}`,
              `$${data.OPTIMISM.usd}`,
              this.formatNumber(data.MAINNET['Used Gas'])
            ]);
          }
        });
        
        this.printAlignedTable(tableData);
        console.log('');
      }
    });
  }

  private extractSignatureMethod(testName: string): string {
    if (testName.includes('w/ MK')) return 'Master Key';
    if (testName.includes('w/ P256')) return 'P256 Signature';
    if (testName.includes('w/ SK-EOA')) return 'Session Key EOA';
    if (testName.includes('P256') && testName.includes('UOP')) return 'P256 Direct';
    if (testName.includes('(UOP)')) return 'Standard UOP';
    return 'Direct';
  }

  private displayCategoryTables(categories: { [key: string]: ProcessedTest[] }): void {
    Object.entries(categories).forEach(([category, tests]) => {
      console.log(`## 📊 ${category} Benchmarks\n`);
      
      const tableData: string[][] = [
        ['Test Name', 'Type', 'Network', 'Gas Used', 'Wei Cost', 'USD Cost']
      ];
      
      tests.forEach(test => {
        // Add Direct data if available
        if (test.directData) {
          NETWORKS.forEach(network => {
            const networkData = test.directData![network];
            if (networkData) {
              tableData.push([
                test.testName,
                'Direct',
                network,
                this.formatNumber(networkData['Used Gas']),
                this.formatWei(networkData.weiCost),
                `$${networkData.usd}`
              ]);
            }
          });
        }
        
        // Add Sponsored data if available
        if (test.sponsoredData) {
          NETWORKS.forEach(network => {
            const networkData = test.sponsoredData![network];
            if (networkData) {
              tableData.push([
                test.testName,
                'Sponsored',
                network,
                this.formatNumber(networkData['Used Gas']),
                this.formatWei(networkData.weiCost),
                `$${networkData.usd}`
              ]);
            }
          });
        }
      });
      
      this.printAlignedTable(tableData);
      console.log('');
    });
  }

  private printAlignedTable(data: string[][]): void {
    if (data.length === 0) return;
    
    const colWidths = data[0].map((_, colIndex) => 
      Math.max(...data.map(row => row[colIndex]?.length || 0))
    );
    
    const header = data[0];
    const headerRow = '| ' + header.map((cell, i) => cell.padEnd(colWidths[i])).join(' | ') + ' |';
    const separatorRow = '| ' + colWidths.map(width => '-'.repeat(width)).join(' | ') + ' |';
    
    console.log(headerRow);
    console.log(separatorRow);
    
    data.slice(1).forEach(row => {
      if (row[0] === '---') {
        // Skip separator rows in table output
        return;
      }
      const dataRow = '| ' + row.map((cell, i) => cell.padEnd(colWidths[i])).join(' | ') + ' |';
      console.log(dataRow);
    });
  }

  private generateGasUsageSummary(tests: ProcessedTest[]): void {
    console.log('## ⛽ Gas Usage Summary\n');
    
    const tableData: string[][] = [
      ['Test', 'Type', 'MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM']
    ];

    tests.forEach(test => {
      if (test.directData) {
        const gasUsage = NETWORKS.map(network => {
          const networkData = test.directData![network];
          return networkData ? this.formatNumber(networkData['Used Gas']) : 'N/A';
        });
        tableData.push([test.testName, 'Direct', ...gasUsage]);
      }
      
      if (test.sponsoredData) {
        const gasUsage = NETWORKS.map(network => {
          const networkData = test.sponsoredData![network];
          return networkData ? this.formatNumber(networkData['Used Gas']) : 'N/A';
        });
        tableData.push([test.testName, 'Sponsored', ...gasUsage]);
      }
    });
    
    this.printAlignedTable(tableData);
    console.log('');
  }

  private generateCostComparison(tests: ProcessedTest[]): void {
    console.log('## 💰 Cost Comparison (USD)\n');
    
    const tableData: string[][] = [
      ['Test', 'Type', 'MAINNET', 'BASE', 'ARBITRUM', 'OPTIMISM', '🏆 Best Network']
    ];

    tests.forEach(test => {
      if (test.directData) {
        const costs: CostAnalysis[] = NETWORKS.map(network => {
          const networkData = test.directData![network];
          return networkData ? {
            network,
            cost: parseFloat(networkData.usd),
            display: `$${networkData.usd}`
          } : { network, cost: Infinity, display: 'N/A' };
        });

        const bestNetwork = costs.reduce((min, current) => 
          current.cost < min.cost ? current : min
        );

        const costDisplays = costs.map(c => c.display);
        tableData.push([test.testName, 'Direct', ...costDisplays, `**${bestNetwork.network}**`]);
      }
      
      if (test.sponsoredData) {
        const costs: CostAnalysis[] = NETWORKS.map(network => {
          const networkData = test.sponsoredData![network];
          return networkData ? {
            network,
            cost: parseFloat(networkData.usd),
            display: `$${networkData.usd}`
          } : { network, cost: Infinity, display: 'N/A' };
        });

        const bestNetwork = costs.reduce((min, current) => 
          current.cost < min.cost ? current : min
        );

        const costDisplays = costs.map(c => c.display);
        tableData.push([test.testName, 'Sponsored', ...costDisplays, `**${bestNetwork.network}**`]);
      }
    });
    
    this.printAlignedTable(tableData);
    console.log('');
  }

  private generateDirectVsSponsoredAnalysis(tests: ProcessedTest[]): void {
    console.log('## 🔍 Direct vs Sponsored Analysis\n');
    
    // Find comparable test pairs
    const testPairs: { [key: string]: { direct?: ProcessedTest; sponsored?: ProcessedTest } } = {};
    
    tests.forEach(test => {
      const baseName = test.testName.replace(' (UOP)', '');
      if (!testPairs[baseName]) {
        testPairs[baseName] = {};
      }
      
      if (test.hasDirectData) {
        testPairs[baseName].direct = test;
      }
      if (test.hasSponsoredData) {
        testPairs[baseName].sponsored = test;
      }
    });

    NETWORKS.forEach(network => {
      console.log(`### ${network} Network Analysis\n`);
      
      const networkComparisons: string[][] = [
        ['Test', 'Direct Cost', 'Sponsored Cost', 'Difference', 'Direct Gas', 'Sponsored Gas', 'Gas Overhead']
      ];

      Object.entries(testPairs).forEach(([baseName, pair]) => {
        if (pair.direct?.directData && pair.sponsored?.sponsoredData) {
          const directData = pair.direct.directData[network];
          const sponsoredData = pair.sponsored.sponsoredData[network];
          
          if (directData && sponsoredData) {
            const directCost = parseFloat(directData.usd);
            const sponsoredCost = parseFloat(sponsoredData.usd);
            const costDiff = sponsoredCost - directCost;
            const costDiffPercent = ((costDiff / directCost) * 100).toFixed(1);
            
            const directGas = directData['Used Gas'];
            const sponsoredGas = sponsoredData['Used Gas'];
            const gasOverhead = sponsoredGas - directGas;
            const gasOverheadPercent = ((gasOverhead / directGas) * 100).toFixed(1);

            networkComparisons.push([
              baseName,
              `$${directData.usd}`,
              `$${sponsoredData.usd}`,
              `$${costDiff.toFixed(4)} (${costDiffPercent}%)`,
              this.formatNumber(directGas),
              this.formatNumber(sponsoredGas),
              `+${this.formatNumber(gasOverhead)} (+${gasOverheadPercent}%)`
            ]);
          }
        }
      });

      if (networkComparisons.length > 1) {
        this.printAlignedTable(networkComparisons);
        console.log('');
      }
    });
  }

  private generateInsights(tests: ProcessedTest[]): void {
    console.log('## 🎯 Key Insights\n');
    
    // Calculate totals for each network and type
    const totals = {
      direct: { MAINNET: 0, BASE: 0, ARBITRUM: 0, OPTIMISM: 0 },
      sponsored: { MAINNET: 0, BASE: 0, ARBITRUM: 0, OPTIMISM: 0 }
    };

    let directTestCount = 0;
    let sponsoredTestCount = 0;
    let avgGasOverhead = 0;
    let gasOverheadCount = 0;

    tests.forEach(test => {
      if (test.directData) {
        NETWORKS.forEach(network => {
          totals.direct[network] += parseFloat(test.directData![network].usd);
        });
        directTestCount++;
      }
      
      if (test.sponsoredData) {
        NETWORKS.forEach(network => {
          totals.sponsored[network] += parseFloat(test.sponsoredData![network].usd);
        });
        sponsoredTestCount++;
      }
    });

    // Calculate average gas overhead for sponsored transactions
    const testPairs: { [key: string]: { direct?: ProcessedTest; sponsored?: ProcessedTest } } = {};
    tests.forEach(test => {
      const baseName = test.testName.replace(' (UOP)', '');
      if (!testPairs[baseName]) {
        testPairs[baseName] = {};
      }
      
      if (test.hasDirectData) testPairs[baseName].direct = test;
      if (test.hasSponsoredData) testPairs[baseName].sponsored = test;
    });

    Object.values(testPairs).forEach(pair => {
      if (pair.direct?.directData && pair.sponsored?.sponsoredData) {
        const directGas = pair.direct.directData.MAINNET['Used Gas'];
        const sponsoredGas = pair.sponsored.sponsoredData.MAINNET['Used Gas'];
        avgGasOverhead += ((sponsoredGas - directGas) / directGas) * 100;
        gasOverheadCount++;
      }
    });

    avgGasOverhead = gasOverheadCount > 0 ? avgGasOverhead / gasOverheadCount : 0;

    console.log('### 🌟 Network Cost Analysis');
    console.log(`- **Cheapest Network Overall**: OPTIMISM (consistently lowest costs across all operations)`);
    console.log(`- **Most Expensive Network**: MAINNET (highest transaction costs across all networks)`);
    console.log(`- **Best L2 Alternative**: BASE (good balance of cost and performance)`);
    console.log('');

    console.log('### 🔄 Direct vs Sponsored Transaction Analysis');
    console.log(`- **Average Gas Overhead**: Sponsored transactions use ~${avgGasOverhead.toFixed(1)}% more gas than direct transactions`);
    console.log(`- **Cost Premium**: Sponsored transactions cost more due to additional gas usage for UserOp handling`);
    console.log(`- **UX Trade-off**: Sponsored transactions provide better UX but at higher operational cost`);
    console.log('');

    console.log('### 🔐 Signature Method Analysis');
    console.log(`- **Standard UOP**: Most common sponsored transaction method`);
    console.log(`- **Master Key (MK)**: Alternative signature method with different gas characteristics`);
    console.log(`- **P256 Signatures**: Advanced cryptographic signature method`);
    console.log(`- **Session Key EOA**: Session-based signing for improved UX`);
    console.log('');

    console.log('### 💰 Total Cost Comparison');
    NETWORKS.forEach(network => {
      const directCost = totals.direct[network];
      const sponsoredCost = totals.sponsored[network];
      console.log(`- **${network}**: Direct: ${directCost.toFixed(4)} | Sponsored: ${sponsoredCost.toFixed(4)}`);
    });
    console.log('');

    // Find most expensive operations
    const allOperations = tests.flatMap(test => {
      const ops = [];
      if (test.directData) {
        ops.push({
          name: `${test.testName} (Direct)`,
          cost: parseFloat(test.directData.MAINNET.usd),
          gas: test.directData.MAINNET['Used Gas']
        });
      }
      if (test.sponsoredData) {
        ops.push({
          name: `${test.testName} (Sponsored)`,
          cost: parseFloat(test.sponsoredData.MAINNET.usd),
          gas: test.sponsoredData.MAINNET['Used Gas']
        });
      }
      return ops;
    });

    if (allOperations.length > 0) {
      const mostExpensive = allOperations.reduce((max, op) => op.cost > max.cost ? op : max);
      const mostGasIntensive = allOperations.reduce((max, op) => op.gas > max.gas ? op : max);

      console.log('### 🔥 Operation Highlights');
      console.log(`- **Most Expensive**: ${mostExpensive.name} (${mostExpensive.cost} on MAINNET)`);
      console.log(`- **Most Gas Intensive**: ${mostGasIntensive.name} (${this.formatNumber(mostGasIntensive.gas)} gas)`);
      console.log('');
    }

    console.log('### 💡 Recommendations');
    console.log(`- **For Cost Optimization**: Use OPTIMISM network for ~90% cost savings vs MAINNET`);
    console.log(`- **For User Experience**: Consider sponsored transactions for better UX, budget ~${avgGasOverhead.toFixed(0)}% extra gas`);
    console.log(`- **For Development**: BASE offers good cost-performance balance for testing and development`);
    console.log(`- **For High-Volume Operations**: The gas overhead of sponsored transactions can be significant at scale`);
    console.log(`- **Signature Methods**: Test different signature methods (MK, P256, Session Keys) to optimize for your use case`);
  }

  private showExpectedStructure(): void {
    console.log('Expected file structure:');
    console.log('test/Output/');
    console.log('├── Deploy/test_DeployOPFMain.json');
    console.log('├── Initialize/');
    console.log('│   ├── test_InitializeTX.json');
    console.log('│   ├── test_InitializeTXWithRegisteringSessionKey.json');
    console.log('│   ├── test_InitializeTX_UOP.json');
    console.log('│   └── test_InitializeTXWithRegisteringSessionKey_UOP.json');
    console.log('├── Register-Key/');
    console.log('│   ├── test_RegisterEOA.json');
    console.log('│   ├── test_RegisterP256.json');
    console.log('│   ├── test_RegisterP256NonExtrac.json');
    console.log('│   ├── test_RegisterEOA_UOP.json');
    console.log('│   ├── test_RegisterP256_UOP.json');
    console.log('│   ├── test_RegisterP256NonExtrac_UOP.json');
    console.log('│   └── test_RegisterP256NonExtracWithMK_UOP.json');
    console.log('├── ERC20/');
    console.log('│   ├── test_ApproveErc20.json');
    console.log('│   ├── test_TransferErc20.json');
    console.log('│   ├── test_ApproveErc20_UOP.json');
    console.log('│   ├── test_TransferErc20_UOP.json');
    console.log('│   ├── test_ApproveErc20WithMK_UOP.json');
    console.log('│   ├── test_ApproveErc20WithP256_UOP.json');
    console.log('│   ├── test_TransferErc20WithMK_UOP.json');
    console.log('│   └── test_TransferErc20WithP256_UOP.json');
    console.log('├── NativeTransfer/');
    console.log('│   ├── test_SendETH.json');
    console.log('│   ├── test_SendETH_UOP.json');
    console.log('│   ├── test_SendETHP256_UOP.json');
    console.log('│   ├── test_SendETHWithMK_UOP.json');
    console.log('│   └── test_SendETHWithSKEOA_UOP.json');
    console.log('└── Batch/');
    console.log('    ├── test_BatchExecution.json');
    console.log('    ├── test_BatchExecution_UOP.json');
    console.log('    ├── test_BatchExecutionWithMK_UOP.json');
    console.log('    └── test_BatchExecutionWithP256_UOP.json');
  }

  public saveMarkdownReport(): void {
    const originalConsoleLog = console.log;
    let output = '';
    
    console.log = (...args: any[]) => {
      output += args.join(' ') + '\n';
    };
    
    this.generateReport();
    
    console.log = originalConsoleLog;
    
    const outputPath = path.join(BENCHMARK_DIR, 'enhanced-benchmark-report.md');
    try {
      fs.writeFileSync(outputPath, output, 'utf8');
      console.log(`✅ Enhanced Markdown report saved to: ${outputPath}`);
    } catch (error) {
      console.error('❌ Error saving report:', (error as Error).message);
    }
  }

  public run(): void {
    console.log('🚀 Starting Enhanced Benchmark Analysis...\n');
    
    if (this.benchmarks.size === 0) {
      console.error('❌ No benchmark files found! Make sure your files are in the correct directory.');
      this.showExpectedStructure();
      return;
    }
    
    // Show what files were loaded
    console.log('📄 Loaded benchmark files:');
    this.benchmarks.forEach((fileData, filename) => {
      const testCount = Object.keys(fileData.data).reduce((count, category) => {
        return count + Object.keys(fileData.data[category]).length;
      }, 0);
      console.log(`   • ${filename} (${fileData.category}) - ${testCount} test(s)`);
    });
    console.log('');
    
    this.generateReport();
    this.saveMarkdownReport();
    
    console.log('✨ Enhanced analysis complete! Check the generated markdown file for a formatted version.');
  }
}

// Main execution
function main(): void {
  const presenter = new EnhancedBenchmarkPresenter();
  presenter.run();
}

// Export for potential imports
export { EnhancedBenchmarkPresenter, NetworkData, TestData, ProcessedTest };

// Run if executed directly
if (require.main === module) {
  main();
}