pragma solidity ^0.4.24;

import "tokenboost-solidity/contracts/widget/Localizable.sol";
import "tokenboost-solidity/contracts/widget/Widgets.sol";
import "../CapStrategy.sol";

contract CapStrategyRenderer is Localizable {
    using Widgets for Widgets.Widget;
    using Elements for Elements.Element;
    using strings for *;
    using UintUtils for uint;

    string public constant CAP = "cap";
    string public constant SHORT_DESC = "short_desc";
    string public constant LONG_DESC = "long_desc";
    string public constant UPDATE = "update";
    string public constant UPDATE_CONFIRM = "update_confirm";

    function adminWidgets(string _locale, CapStrategy _strategy) public view returns (string) {
        string memory json = "[";
        uint length = 0;
        string[1] memory widgets = [
        _capWidget(_locale, _strategy)
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

    function _capWidget(string _locale, CapStrategy _strategy) private view returns (string json) {
        Elements.Element[] memory elements = new Elements.Element[](1);
        elements[0] = Elements.Element(
            true,
            CAP,
            "eth",
            resources[_locale][CAP],
            _strategy.cap().toString(),
            Actions.empty(),
            Tables.empty()
        );
        Widgets.Widget memory widget = Widgets.Widget(
            resources[_locale][CAP],
            resources[_locale][SHORT_DESC],
            resources[_locale][LONG_DESC],
            4,
            elements
        );
        return widget.toJson();
    }

    function userWidgets(string _locale, CapStrategy _strategy) public view returns (string json) {
        return "[]";
    }

    function inputs(string _locale, CapStrategy _strategy) public view returns (string) {
        Elements.Element[] memory elements = new Elements.Element[](2);
        elements[0] = Elements.Element(
            true,
            CAP,
            "ethEdit",
            resources[_locale][CAP],
            _strategy.cap().toString(),
            Actions.empty(),
            Tables.empty()
        );
        elements[1] = Elements.Element(
            true,
            UPDATE,
            "button",
            resources[_locale][UPDATE],
            "null",
            Actions.Action(
                true,
                address(_strategy),
                "update(uint256)",
                '["cap"]',
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
