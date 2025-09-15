// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "lib/forge-std/src/Test.sol";

abstract contract JsonOut is Test {
    struct ChainRow {
        string chain;
        uint256 gas;
        uint256 weiCost;
        string usd;
    }

    struct ModeData {
        string name;
        ChainRow[] rows;
    }

    struct Ctx {
        string bench;
        string test;
        ModeData[] modes;
    }

    Ctx internal _ctx;
    uint256 internal _curMode;
    string internal constant DEFAULT_PATH = "test/Output/Benchmarks.json";

    function _u(uint256 x) internal pure returns (string memory) {
        return vm.toString(x);
    }

    function _abs(string memory rel) internal view returns (string memory) {
        return string.concat(vm.projectRoot(), "/", rel);
    }

    function _beginTest(string memory bench, string memory test) internal {
        delete _ctx;
        _ctx.bench = bench;
        _ctx.test = test;
        _curMode = type(uint256).max;
    }

    function _beginMode(string memory mode) internal {
        _ctx.modes.push();
        _curMode = _ctx.modes.length - 1;
        _ctx.modes[_curMode].name = mode;
    }

    function _push(string memory chain, uint256 gas, uint256 weiCost, string memory usd) internal {
        ModeData storage m = _ctx.modes[_curMode];
        m.rows.push(ChainRow(chain, gas, weiCost, usd));
    }

    function _flushTo(string memory relPath) internal {
        string memory json = string.concat('{"', _ctx.bench, '":{"', _ctx.test, '":{');

        for (uint256 i = 0; i < _ctx.modes.length; i++) {
            ModeData storage m = _ctx.modes[i];
            json = string.concat(json, '"', m.name, '":{');

            for (uint256 j = 0; j < m.rows.length; j++) {
                ChainRow storage r = m.rows[j];
                json = string.concat(
                    json,
                    '"',
                    r.chain,
                    '":{',
                    '"Used Gas":',
                    _u(r.gas),
                    ",",
                    '"weiCost":',
                    _u(r.weiCost),
                    ",",
                    '"usd":"',
                    r.usd,
                    '"',
                    "}",
                    (j + 1 == m.rows.length) ? "" : ","
                );
            }

            json = string.concat(json, "}", (i + 1 == _ctx.modes.length) ? "" : ",");
        }

        json = string.concat(json, "}}}");

        vm.writeFile(_abs(relPath), json);
    }

    function _flush() internal {
        _flushTo(DEFAULT_PATH);
    }
}
