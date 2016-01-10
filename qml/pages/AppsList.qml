import QtQuick 2.0
import Sailfish.Silica 1.0

import harbour.mimer.DesktopFileSortModel 1.0

Page {
    id: page

    signal selected(string name, string icon, string exec, string desktop)
    property bool searchEnabled: false
    property variant selectedValues: []
    property bool showHidden: false

    SilicaFlickable {
        id: view
        anchors.fill: page
        contentHeight: content.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Reset / Set default")
                onClicked: {
                    selected("Default", "", "", "")
                    pageStack.pop()
                }
            }
            MenuItem {
                text: searchEnabled
                      ? qsTr("Hide search field")
                      : qsTr("Show search field")
                enabled: shortcutsRepeater.count > 0
                onClicked: {
                    searchEnabled = !searchEnabled
                }
            }
            MenuItem {
                text: showHidden
                      ? qsTr("Hide hidden Applications")
                      : qsTr("Show hidden Applications")
                enabled: shortcutsRepeater.count > 0
                onClicked: {
                    showHidden = !showHidden
                }
            }
        }

        Column {
            id: content
            width: parent.width

            PageHeader {
                id: title
                title: qsTr("Select App")
            }

            Item {
                id: searchFieldPlaceholder
                width: parent.width

                height: !searchField.enabled ? 0 : searchField.height
                Behavior on height {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            SearchField {
                id: searchField
                parent: searchFieldPlaceholder
                width: parent.width
                enabled: page.searchEnabled
                onEnabledChanged: {
                    if (!enabled) {
                        text = ''
                    }
                }
                focus: enabled
                visible: opacity > 0
                opacity: page.searchEnabled ? 1 : 0
                Behavior on opacity {
                    FadeAnimation {
                        duration: 150
                    }
                }
            }

            Repeater {
                id: shortcutsRepeater
                delegate: shortcutDelegate
                model: desktopModel
                width: parent.width
                enabled: false
            }
        }

        VerticalScrollDecorator {}
    }

    BusyIndicator {
        anchors.centerIn: view
        size: BusyIndicatorSize.Large
        visible: !shortcutsRepeater.enabled
        running: visible
    }

    DesktopFileSortModel {
        id: desktopModel
        filter: searchField.text
        onDataFillEnd: {
            shortcutsRepeater.enabled = true
        }
    }

    Component {
        id: shortcutDelegate
        BackgroundItem {
            id: item
            width: parent.width
            contentHeight: Theme.itemSizeLarge
            height: Theme.itemSizeLarge
            property bool isSelected: selectedValues.indexOf(model.exec) >= 0
            highlighted: down || isSelected
            visible: showHidden ? true : !model.nodisplay

            Image {
                id: iconImage
                source: model.icon
                width: Theme.iconSizeLauncher
                height: Theme.iconSizeLauncher
                smooth: true
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                text: Theme.highlightText(model.name, searchField.text, Theme.highlightColor)
                anchors {
                    left: iconImage.right
                    leftMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
                color: item.pressed ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked: {
                if (shortcutsRepeater.enabled) {
                    selected(model.name,model.icon,model.exec,model.path)
                    pageStack.pop();
                }
            }
        }
    }
}


