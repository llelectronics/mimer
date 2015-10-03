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

    property string mimeappslist:  _helper.getHome() + "/.local/share/applications/mimeapps.list"
    property string defaultslist:  _helper.getHome() + "/.local/share/applications/defaults.list"

    RemorsePopup { id: remorse }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                id: resetAllMenuItem
                text: qsTr("Set everything to defaults")
                visible: _helper.isFile(mimeappslist)
                onClicked: {
                    remorse.execute("Resetting everything", function() {
                        if (_helper.isFile(mimeappslist)) _helper.remove(mimeappslist)
                        if (_helper.isFile(defaultslist) || _helper.isLink(defaultslist)) _helper.remove(defaultslist)
                    } )
                }
            }
            MenuItem {
                id: manualEditMenuItem
                text: qsTr("Manual edit")
                visible: {
                    if (_helper.isFile(mimeappslist) && _helper.isFile("/usr/bin/harbour-tinyedit")) return true
                    else return false
                }
                onClicked: {
                    mainWindow.infoBanner.showText(qsTr("Opening..."));
                    _helper.openFileWith("/usr/bin/harbour-tinyedit",mimeappslist);
                }
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
//                                if ((exec.indexOf("%u") !=-1) || (exec.indexOf("%U") != -1)) {
//                                    browserChooseBtn.exec = exec;
//                                }
//                                else { browserChooseBtn.exec = exec + " '%U'"; }
                                console.debug("Selected: " + browserChooseBtn.value + " with desktopfile: " + desktop + " and icon image: " + icon)
                                //_helper.setDefaultBrowser(browserChooseBtn.exec);
                                var desktopfile = desktop.substring(desktop.lastIndexOf('/') + 1)
                                _helper.setMime("text/html", desktopfile);
                                _helper.setMime("x-maemo-urischeme/http", desktopfile);
                                _helper.setMime("x-maemo-urischeme/https", desktopfile);
                            }
                            else {
                                browserChooseBtn.value = qsTr("Change");
                                browserChooseBtn.exec = exec
                                browserIcon.icon.source = "image://theme/icon-launcher-browser"
                                console.debug("Resetted browser to default")
                                //_helper.remove(_helper.getHome() + "/.local/share/applications/open-url.desktop")
                                _helper.setMime("text/html", "open-url.desktop");
                                _helper.setMime("x-maemo-urischeme/http", "open-url.desktop");
                                _helper.setMime("x-maemo-urischeme/https", "open-url.desktop");
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
                                var desktopfile = imageChooseBtn.desktop.substring(imageChooseBtn.desktop.lastIndexOf('/') + 1)
                                _helper.setMime("image/jpeg",desktopfile)
                                _helper.setMime("image/gif", desktopfile)
                                _helper.setMime("image/png", desktopfile)
                            }
                            else {
                                imageChooseBtn.value = qsTr("Change");
                                imageChooseBtn.desktop = desktop
                                imageViewerIcon.icon.source = "image://theme/icon-launcher-gallery"
                                console.debug("Resetted image viewer to default")
                                _helper.setMime("image/jpeg", "jolla-gallery-openfile.desktop")
                                _helper.setMime("image/gif", "jolla-gallery-openfile.desktop")
                                _helper.setMime("image/png", "jolla-gallery-openfile.desktop")
                            }
                        })
                    }
                }
            }
            Row {
                width: parent.width
                IconButton {
                    id: musicIcon
                    icon.source: "image://theme/icon-launcher-mediaplayer"
                    width: 86
                    height: 86
                    x: Theme.paddingLarge
                }

                ValueButton {
                    id: musicChooseBtn
                    label: qsTr("Music Player")
                    value: qsTr("Change")
                    property string desktop
                    onClicked: {
                        var selector = pageStack.push(Qt.resolvedUrl("AppsList.qml"))
                        selector.selected.connect(function(name,icon,exec,desktop) {
                            if (name !== "Default") {
                                musicChooseBtn.value = name;
                                if (icon.length !== 0) musicIcon.icon.source = icon;
                                musicChooseBtn.desktop = desktop;
                                console.debug("Selected: " + musicChooseBtn.value + " with desktopfile: " + musicChooseBtn.desktop + " and icon image: " + icon)
                                var desktopfile = musicChooseBtn.desktop.substring(musicChooseBtn.desktop.lastIndexOf('/') + 1)
                                _helper.setMime("audio/aac", desktopfile)
                                _helper.setMime("audio/flac", desktopfile)
                                _helper.setMime("audio/mp4", desktopfile)
                                _helper.setMime("audio/mpeg", desktopfile)
                                _helper.setMime("audio/ogg", desktopfile)
                                _helper.setMime("audio/x-vorbis+ogg", desktopfile)
                                _helper.setMime("audio/x-wav", desktopfile)
                            }
                            else {
                                musicChooseBtn.value = qsTr("Change");
                                musicChooseBtn.desktop = desktop
                                musicIcon.icon.source = "image://theme/icon-launcher-mediaplayer"
                                console.debug("Resetted music player to default")
                                _helper.setMime("audio/aac", "jolla-mediaplayer-openfile.desktop")
                                _helper.setMime("audio/flac", "jolla-mediaplayer-openfile.desktop")
                                _helper.setMime("audio/mp4", "jolla-mediaplayer-openfile.desktop")
                                _helper.setMime("audio/mpeg", "jolla-mediaplayer-openfile.desktop")
                                _helper.setMime("audio/ogg", "jolla-mediaplayer-openfile.desktop")
                                _helper.setMime("audio/x-vorbis+ogg", "jolla-mediaplayer-openfile.desktop")
                                _helper.setMime("audio/x-wav", "jolla-mediaplayer-openfile.desktop")
                            }
                        })
                    }
                }
            }
            Row {
                width: parent.width
                IconButton {
                    id: videoIcon
                    icon.source: "image://theme/icon-launcher-gallery"
                    width: 86
                    height: 86
                    x: Theme.paddingLarge
                }

                ValueButton {
                    id: videoChooseBtn
                    label: qsTr("Video Player")
                    value: qsTr("Change")
                    property string desktop
                    onClicked: {
                        var selector = pageStack.push(Qt.resolvedUrl("AppsList.qml"))
                        selector.selected.connect(function(name,icon,exec,desktop) {
                            if (name !== "Default") {
                                videoChooseBtn.value = name;
                                if (icon.length !== 0) videoIcon.icon.source = icon;
                                videoChooseBtn.desktop = desktop;
                                console.debug("Selected: " + videoChooseBtn.value + " with desktopfile: " + videoChooseBtn.desktop + " and icon image: " + icon)
                                var desktopfile = videoChooseBtn.desktop.substring(videoChooseBtn.desktop.lastIndexOf('/') + 1)
                                _helper.setMime("video/mp4", desktopfile)
                                _helper.setMime("video/dv", desktopfile)
                                _helper.setMime("video/mp2t", desktopfile)
                                _helper.setMime("video/mp4v-es", desktopfile)
                                _helper.setMime("video/mpeg", desktopfile)
                                _helper.setMime("video/msvideo", desktopfile)
                                _helper.setMime("video/quicktime", desktopfile)
                                _helper.setMime("video/vnd.rn-realvideo", desktopfile)
                                _helper.setMime("video/webm", desktopfile)
                                _helper.setMime("video/x-avi", desktopfile)
                                _helper.setMime("video/x-flv", desktopfile)
                                _helper.setMime("video/x-matroska", desktopfile)
                                _helper.setMime("video/x-mpeg", desktopfile)
                                _helper.setMime("video/x-ms-asf", desktopfile)
                                _helper.setMime("video/x-ms-wmv", desktopfile)
                                _helper.setMime("video/x-msvideo", desktopfile)
                                _helper.setMime("video/x-ogm+ogg", desktopfile)
                                _helper.setMime("x-maemo-urischeme/mms", desktopfile)
                                _helper.setMime("x-maemo-urischeme/rtmp", desktopfile)
                                _helper.setMime("x-maemo-urischeme/rtsp", desktopfile)
                            }
                            else {
                                videoChooseBtn.value = qsTr("Change");
                                videoChooseBtn.desktop = desktop
                                videoIcon.icon.source = "image://theme/icon-launcher-gallery"
                                console.debug("Resetted video player to default")
                                _helper.setMime("video/mp4", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/dv", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/mp2t", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/mp4v-es", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/mpeg", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/msvideo", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/quicktime", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/vnd.rn-realvideo", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/webm", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-avi", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-flv", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-matroska", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-mpeg", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-ms-asf", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-ms-wmv", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-msvideo", "jolla-gallery-openfile.desktop")
                                _helper.setMime("video/x-ogm+ogg", "jolla-gallery-openfile.desktop")
                                _helper.setMime("x-maemo-urischeme/mms", "jolla-gallery-playvideostream.desktop")
                                _helper.setMime("x-maemo-urischeme/rtmp", "jolla-gallery-playvideostream.desktop")
                                _helper.setMime("x-maemo-urischeme/rtsp", "jolla-gallery-playvideostream.desktop")
                            }
                        })
                    }
                }
            }
        }
    }
}


