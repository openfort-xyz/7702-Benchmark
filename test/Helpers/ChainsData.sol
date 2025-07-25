// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Interfaces} from "test/helpers/Interfaces.sol";
import {Test} from "lib/forge-std/src/Test.sol";

contract ChainsData is Test, Interfaces {
    ChainRPC[] internal rpcs;
    mapping(bytes32 => ChainFees) public fees;
    uint256 public ethPriceUsdE8;

    string public MAINNET_RPC = "https://ethereum-rpc.publicnode.com";
    string public BASE_RPC    = "https://base-rpc.publicnode.com";
    string public ARB_RPC     = "https://arbitrum-one-rpc.publicnode.com";
    string public OP_RPC      = "https://optimism-rpc.publicnode.com";

    function setUp() virtual public {
        _setRpcs();
        _loadChainsFromEnv();
    }

    function _setRpcs() internal {
        rpcs.push(ChainRPC({url: MAINNET_RPC, name: "MAINNET"}));
        rpcs.push(ChainRPC({url: BASE_RPC,    name: "BASE"}));
        rpcs.push(ChainRPC({url: ARB_RPC,     name: "ARBITRUM"}));
        rpcs.push(ChainRPC({url: OP_RPC,      name: "OPTIMISM"}));
    }

    function _key(string memory name) internal pure returns (bytes32) {
        return keccak256(bytes(name));
    }

    function _loadChainsFromEnv() internal {
        ethPriceUsdE8 = vm.envUint("ETH_PRICE_USD") * 1e8;

        fees[_key("MAINNET")] = ChainFees({
            gasPrice: vm.envUint("ETH_GAS_PRICE"),
            isOPStack: false,
            op: OPStackFeeParams(0,0,0,0,0)
        });

        fees[_key("ARBITRUM")] = ChainFees({
            gasPrice: vm.envUint("ARB_GAS_PRICE"),
            isOPStack: false,
            op: OPStackFeeParams(0,0,0,0,0)
        });

        fees[_key("OPTIMISM")] = ChainFees({
            gasPrice: 0,
            isOPStack: true,
            op: OPStackFeeParams({
                l2GasPrice:        vm.envUint("OPT_GAS_PRICE"),
                l1BaseFee:         vm.envUint("OPT_L1_BASE_FEE"),
                l1BaseFeeScalar:   vm.envUint("OPT_L1_BASE_FEE_SCALAR"),
                blobBaseFee:       vm.envUint("OPT_BLOB_BASE_FEE"),
                blobBaseFeeScalar: vm.envUint("OPT_BLOB_BASE_FEE_SCALAR")
            })
        });

        fees[_key("BASE")] = ChainFees({
            gasPrice: 0,
            isOPStack: true,
            op: OPStackFeeParams({
                l2GasPrice:        vm.envUint("BASE_GAS_PRICE"),
                l1BaseFee:         vm.envUint("BASE_L1_BASE_FEE"),
                l1BaseFeeScalar:   vm.envUint("BASE_L1_BASE_FEE_SCALAR"),
                blobBaseFee:       vm.envUint("BASE_BLOB_BASE_FEE"),
                blobBaseFeeScalar: vm.envUint("BASE_BLOB_BASE_FEE_SCALAR")
            })
        });
    }
}