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
import "../components"

Page {
    id: page

    property string mimeappslist
    property string defaultslist:  _helper.getHome() + "/.local/share/applications/defaults.list"
    property bool mimeAppsListExist

    function mimeAppsListReread() {
        if (_helper.isFile(_helper.getHome() + "/.local/share/applications/mimeapps.list"))
            mimeappslist = _helper.getHome() + "/.local/share/applications/mimeapps.list"
        else if (_helper.isFile(_helper.getHome() + "/.config/mimeapps.list"))
            mimeappslist = _helper.getHome() + "/.config/mimeapps.list"
        else
            mimeappslist = ""

        mimeAppsListExist = _helper.isFile(mimeappslist)
    }

    Component.onCompleted: {
        mimeAppsListReread()
    }

    RemorsePopup { id: remorse }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                id: resetAllMenuItem
                text: qsTr("Set everything to defaults")
                visible: mimeAppsListExist
                onClicked: {
                    remorse.execute("Resetting everything", function() {
                        if (_helper.isFile(mimeappslist)) _helper.remove(mimeappslist)
                        if (_helper.isFile(defaultslist) || _helper.isLink(defaultslist)) _helper.remove(defaultslist)
                        mimeAppsListReread()
                        config.value = [{}]
                        var list = column.children
                        for (var i in list) {
                            if (list[i].objectName === "appItem")
                                list[i].reset()
                        }
                    } )
                }
            }
            MenuItem {
                id: manualEditMenuItem
                text: qsTr("Manual edit")
                visible: mimeAppsListExist
                onClicked: {
                    infoBanner.showText(qsTr("Opening..."));
                    Qt.openUrlExternally(mimeappslist)
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
            PageHeader {
                title: qsTr("Set default apps")
            }

            AppItem {
                id: appItem
                label: qsTr("Browser")
                defaultValue: qsTr("Change")
                defaultIconSource: "image://theme/icon-launcher-browser"
                customMimeTypeList: ["text/html", "x-scheme-handler/http", "x-scheme-handler/https"]
                onDefaultSelected: {
                    setMimeList(defaultMimeTypeList, "open-url.desktop")
                }
            }
            AppItem {
                label: qsTr("Image Viewer")
                defaultValue: qsTr("Change")
                defaultIconSource: "image://theme/icon-launcher-gallery"
                customMimeTypeList: ["image/bmp", "image/jpeg", "image/gif", "image/png", "image/tiff"]
                onDefaultSelected: {
                    setMimeList(defaultMimeTypeList, "jolla-gallery-openfile.desktop")
                }
            }

            AppItem {
                label: qsTr("Music Player")
                defaultValue: qsTr("Change")
                defaultIconSource: "image://theme/icon-launcher-mediaplayer"
                customMimeTypeList: ["audio/aac", "audio/flac", "audio/mp4", "audio/mpeg", "audio/ogg", "audio/x-vorbis+ogg", "audio/x-wav"]
                onDefaultSelected: {
                    setMimeList(defaultMimeTypeList, "jolla-mediaplayer-openfile.desktop")
                }
            }

            AppItem {
                label: qsTr("Video Player")
                defaultValue: qsTr("Change")
                defaultIconSource: "image://theme/icon-launcher-gallery"
                defaultMimeTypeList: ["video/mp4", "video/dv", "video/mp2t", "video/mp4v-es", "video/mpeg", "video/msvideo", "video/quicktime",
                    "video/vnd.rn-realvideo", "video/webm", "video/x-avi", "video/x-flv", "video/x-matroska", "video/x-mpeg", "video/x-ms-asf",
                    "video/x-ms-wmv", "video/x-msvideo", "video/x-ogm+ogg"]
                customMimeTypeList: ["video/mp4", "video/dv", "video/mp2t", "video/mp4v-es", "video/mpeg", "video/msvideo", "video/quicktime",
                    "video/vnd.rn-realvideo", "video/webm", "video/x-avi", "video/x-flv", "video/x-matroska", "video/x-mpeg", "video/x-ms-asf",
                    "video/x-ms-wmv", "video/x-msvideo", "video/x-ogm+ogg", "x-scheme-handler/mms", "x-scheme-handler/rtmp", "x-scheme-handler/rtsp"]
                onDefaultSelected: {
                    setMimeList(defaultMimeTypeList, "jolla-gallery-openfile.desktop")
                    var schemeList = ["x-scheme-handler/mms", "x-scheme-handler/rtmp", "x-scheme-handler/rtsp"]
                    setMimeList(schemeList, "jolla-gallery-playvideostream.desktop")
                }
            }

            AppItem {
                label: qsTr("Text Editor")
                defaultValue: qsTr("Change")
                defaultIconSource: "image://theme/icon-launcher-notes"
                defaultMimeTypeList: ["text/plain"]
                customMimeTypeList: ["text/plain", "text/x-c", "text/x-c++"]
                onDefaultSelected: {
                    setMimeList(defaultMimeTypeList, "jolla-notes-import.desktop")
                }
            }
        }
    }

    InfoBanner {
        id: infoBanner
        z:1
    }
}


