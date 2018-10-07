import QtQuick 2.0
import Sailfish.Silica 1.0

ValueButton {
    id: appItem
    contentHeight: Theme.itemSizeLarge
    leftMargin: browserIcon.width + 2*Theme.paddingMedium
    value: defaultValue
    objectName: "appItem"

    property string defaultValue
    property string defaultIconSource
    property string desktopFilePath
    property string iconSource
    property string action
    property var defaultMimeTypeList: customMimeTypeList
    property var customMimeTypeList: []
    signal customSelected(string desktopFile)
    signal defaultSelected()

    Image {
        id: browserIcon
        width: Theme.iconSizeLauncher
        height: Theme.iconSizeLauncher
        anchors.verticalCenter: parent.verticalCenter
        x: Theme.paddingMedium
        source: iconSource.length > 1 ? iconSource : defaultIconSource
    }

    property string exec
    onClicked: {
        var selector = pageStack.push(Qt.resolvedUrl("../pages/AppsList.qml"))
        selector.selected.connect(function (name,icon,exec,desktopFilePath) {
            appItem.exec = exec
            appItem.desktopFilePath = desktopFilePath
            if (name === "Default") {
                appItem.value = defaultValue
                iconSource = ""
                console.debug("Resetted " + appItem.label + "to default")
                appItem.defaultSelected()

                config.removeApp(appItem.label)
            } else {
                appItem.value = name;
                if (icon.length !== 0)
                    iconSource = icon
                console.debug("Selected: " + appItem.value + " with desktopfile: " + appItem.desktopFilePath + " and icon image: " + icon)
                var desktopFile = appItem.desktopFilePath.substring(appItem.desktopFilePath.lastIndexOf('/') + 1)
                appItem.action = desktopFile.split(".")[0]
                setMimeList(customMimeTypeList, desktopFile)
                appItem.customSelected(desktopFile)

                config.removeApp(appItem.label)
                var list = config.value
                list.splice(0,0, {
                                name: appItem.label,
                                value: appItem.value,
                                icon: appItem.iconSource,
                                desktopFile: desktopFile,
                                desktopFilePath: appItem.desktopFilePath,
                                action: appItem.action
                            })
                config.value = list

                mimeAppsListReread()
            }
        })
    }

    function setMimeList(mimeList, desktopFile) {
        for (var i in mimeList) {
            //console.log("set mime: " + mimeList[i])
            _helper.setMime(mimeList[i], desktopFile);
        }
    }

    function isCustom() {
        var app = config.getApp(appItem.label)
        if (app === null)
            return false
        for (var i in customMimeTypeList) {
            var action = _helper.actionForMime(customMimeTypeList[i])
            if (action.indexOf(app.action) !== 0) {
                return false
            }
        }
        return true
    }

    function reset() {
        appItem.value = appItem.defaultValue
        appItem.iconSource = appItem.defaultIconSource
    }

    Component.onCompleted: {
        if (isCustom()) {
            var app = config.getApp(appItem.label)
            iconSource = app.icon
            appItem.value = app.value;
        }
    }
}
