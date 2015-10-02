/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Set default apps")
            }
            Row {
                width: parent.width
                IconButton {
                    id: browserIcon
                    icon.source: "image://theme/icon-launcher-browser"
                    width: 86
                    height: 86
                    x: Theme.paddingLarge
                }

                ValueButton {
                    id: browserChooseBtn
                    label: qsTr("Browser")
                    value: qsTr("Change")
                    property string exec
                    onClicked: {
                        var selector = pageStack.push(Qt.resolvedUrl("AppsList.qml"))
                        selector.selected.connect(function(name,icon,exec,desktop) {
                            if (name !== "Default") {
                                browserChooseBtn.value = name;
                                if (icon.length !== 0) browserIcon.icon.source = icon;
                                if ((exec.indexOf("%u") !=-1) || (exec.indexOf("%U") != -1)) {
                                    browserChooseBtn.exec = exec;
                                }
                                else { browserChooseBtn.exec = exec + " '%U'"; }
                                console.debug("Selected: " + browserChooseBtn.value + " with exec: " + browserChooseBtn.exec + " and icon image: " + icon)
                                _helper.setDefaultBrowser(browserChooseBtn.exec);
                            }
                            else {
                                browserChooseBtn.value = qsTr("Change");
                                browserChooseBtn.exec = exec
                                browserIcon.icon.source = "image://theme/icon-launcher-browser"
                                console.debug("Resetted browser to default")
                                _helper.remove(_helper.getHome() + "/.local/share/applications/open-url.desktop")
                            }
                        })
                    }
                }
            }
            Row {
                width: parent.width
                IconButton {
                    id: imageViewerIcon
                    icon.source: "image://theme/icon-launcher-gallery"
                    width: 86
                    height: 86
                    x: Theme.paddingLarge
                }

                ValueButton {
                    id: imageChooseBtn
                    label: qsTr("Image Viewer")
                    value: qsTr("Change")
                    property string desktop
                    onClicked: {
                        var selector = pageStack.push(Qt.resolvedUrl("AppsList.qml"))
                        selector.selected.connect(function(name,icon,exec,desktop) {
                            if (name !== "Default") {
                                imageChooseBtn.value = name;
                                if (icon.length !== 0) imageViewerIcon.icon.source = icon;
                                imageChooseBtn.desktop = desktop;
                                console.debug("Selected: " + imageChooseBtn.value + " with desktopfile: " + imageChooseBtn.desktop + " and icon image: " + icon)
                                _helper.setMime("image/jpeg",imageChooseBtn.desktop.substring(imageChooseBtn.desktop.lastIndexOf('/') + 1));
                            }
                            else {
                                imageChooseBtn.value = qsTr("Change");
                                imageChooseBtn.desktop = desktop
                                imageViewerIcon.icon.source = "image://theme/icon-launcher-gallery"
                                console.debug("Resetted image viewer to default")
                                _helper.setMime("image/jpeg", "jolla-gallery-openfile.desktop")
                            }
                        })
                    }
                }
            }
        }
    }
}


