pragma solidity ^0.4.24;

import "tokenboost-solidity/contracts/widget/Localizable.sol";
import "tokenboost-solidity/contracts/widget/Widgets.sol";
import "../SoftHardCapStrategy.sol";

contract SoftHardCapStrategyRenderer is Localizable {
    using Widgets for Widgets.Widget;
    using Elements for Elements.Element;
    using strings for *;
    using UintUtils for uint;

    string public constant SOFT_CAP = "soft_cap";
    string public constant SOFT_CAP_SHORT_DESC = "soft_cap_short_desc";
    string public constant SOFT_CAP_LONG_DESC = "soft_cap_long_desc";
    string public constant HARD_CAP = "hard_cap";
    string public constant HARD_CAP_SHORT_DESC = "hard_cap_short_desc";
    string public constant HARD_CAP_LONG_DESC = "hard_cap_long_desc";
    string public constant UPDATE = "update";
    string public constant UPDATE_CONFIRM = "update_confirm";

    function adminWidgets(string _locale, SoftHardCapStrategy _strategy) public view returns (string) {
        string memory json = "[";
        uint length = 0;
        string[2] memory widgets = [
        _softCapWidget(_locale, _strategy),
        _hardCapWidget(_locale, _strategy)
        ];
        for (uint i = 0; i < widgets.length; i++) {
            string memory widget = widgets[i];
            if (bytes(widget).length > 0) {
                if (length > 0) {
                    json = json.toSlice().concat(",".toSlice());
                }
                json = json.toSlice().concat(widget.toSlice());
                length++;
            }
        }
        return json.toSlice().concat("]".toSlice());
    }

    function _softCapWidget(string _locale, SoftHardCapStrategy _strategy) private view returns (string json) {
        if (_strategy.sale().started()) {
            Elements.Element[] memory elements = new Elements.Element[](1);
            elements[0] = Elements.Element(
                true,
                SOFT_CAP,
                "eth",
                "null",
                _strategy.softCap().toString(),
                Actions.empty(),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][SOFT_CAP],
                resources[_locale][SOFT_CAP_SHORT_DESC],
                resources[_locale][SOFT_CAP_LONG_DESC],
                4,
                elements
            );
            return widget.toJson();
        } else {
            return "";
        }
    }

    function _hardCapWidget(string _locale, SoftHardCapStrategy _strategy) private view returns (string json) {
        if (_strategy.sale().finished()) {
            Elements.Element[] memory elements = new Elements.Element[](1);
            elements[0] = Elements.Element(
                true,
                HARD_CAP,
                "eth",
                "null",
                _strategy.hardCap().toString(),
                Actions.empty(),
                Tables.empty()
            );
            Widgets.Widget memory widget = Widgets.Widget(
                resources[_locale][HARD_CAP],
                resources[_locale][HARD_CAP_SHORT_DESC],
                resources[_locale][HARD_CAP_LONG_DESC],
                4,
                elements
            );
            return widget.toJson();
        } else {
            return "";
        }
    }

    function userWidgets(string _locale, SoftHardCapStrategy _strategy) public view returns (string json) {
        return "[]";
    }

    function inputs(string _locale, SoftHardCapStrategy _strategy) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](3);
        elements[0] = Elements.Element(
            true,
            SOFT_CAP,
            "ethEdit",
            resources[_locale][SOFT_CAP],
            _strategy.softCap().toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[1] = Elements.Element(
            true,
            HARD_CAP,
            "ethEdit",
            resources[_locale][HARD_CAP],
            _strategy.hardCap().toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[2] = Elements.Element(
            true,
            UPDATE,
            "button",
            resources[_locale][UPDATE],
            "null",
            Actions.Action(
                true,
                address(_strategy),
                "update(uint256,uint256)",
                '["soft_cap","hard_cap"]',
                resources[_locale][UPDATE_CONFIRM]
            ),
            Tables.empty()
        );
        string memory json = "[";
        for (uint i = 0; i < elements.length; i++) {
            if (i > 0) {
                json = json.toSlice().concat(','.toSlice());
            }
            json = json.toSlice().concat(elements[i].toJson().toSlice());
        }
        return json.toSlice().concat(']'.toSlice());
    }
}
