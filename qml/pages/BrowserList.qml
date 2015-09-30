import QtQuick 2.0
import Sailfish.Silica 1.0

ListModel {
    id: browserModel
    ListElement {
        name: "Webcat"
        exec: "/usr/bin/harbour-webcat %U"
    }
    ListElement {
        name: "Webpirate"
        exec: "/usr/bin/harbour-webcat %U"
    }
    ListElement {
        name: "Firefox (Android)"
        exec: "/opt/alien/system/bin/adb -e shell am start -a android.intent.action.VIEW -n org.mozilla.firefox/.App -d ' %U'"
    }
    ListElement {
        name: "Custom"
        exec: ""
    }
}
