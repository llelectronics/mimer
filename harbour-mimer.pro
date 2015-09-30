# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-mimer

CONFIG += sailfishapp

PKGCONFIG += mlite5

SOURCES += src/harbour-mimer.cpp \
    src/desktopfilesortmodel.cpp \
    src/desktopfilemodelplugin.cpp \
    src/desktopfilemodel.cpp

OTHER_FILES += qml/harbour-mimer.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-mimer.changes.in \
    rpm/harbour-mimer.spec \
    rpm/harbour-mimer.yaml \
    translations/*.ts \
    harbour-mimer.desktop \
    qml/pages/AboutPage.qml \
    qml/pages/AppsList.qml \
    qml/pages/BrowserList.qml \
    qml/pages/CreditsModel.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-mimer-de.ts

HEADERS += \
    src/desktopfilesortmodel.h \
    src/desktopfilemodelplugin.h \
    src/desktopfilemodel.h \
    src/helper.hpp

