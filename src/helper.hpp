#ifndef HELPER_HPP
#define HELPER_HPP

#include <QtCore/QObject>
#include <QtCore/QFile>
#include <QString>
#include <QDebug>
#include <QDir>
#include <QFileInfo>
#include <QUrl>
#include <QTextStream>
#include <QProcess>
#include <contentaction5/contentaction.h>

class Helper : public QObject
{   Q_OBJECT
    public slots:
        void remove(const QString &url)
        {    //qDebug() << "Called the C++ slot and request removal of:" << url;
             QFile(url).remove();
        }
        QString getHome()
        {    //qDebug() << "Called the C++ slot and request removal of:" << url;
             return QDir::homePath();
        }
        QString getRoot()
        {    //qDebug() << "Called the C++ slot and request removal of:" << url;
             return QDir::rootPath();
        }
        bool existsPath(const QString &url)
        {
            return QDir(url).exists();
        }
        bool isFile(const QString &url)
        {
            return QFileInfo(url).isFile();
        }
        bool isLink(const QString &url)
        {
            return QFileInfo(url).isSymLink();
        }
        bool resetBrowser()
        {
            if (isFile("/usr/bin/harbour-webcat")) {
                QProcess mimeProc;
                mimeProc.start("harbour-webcat --reset-default");
                mimeProc.waitForFinished();
            }
            return true;
        }
        /* Just for testing purposes. I just don't want to get killed by CODeRUS so not using this :P */
//        int setDefaultBrowser(const QString &execLine)
//        {
//            /* Search if file exists. If yes remove it */
//            if (isFile(getHome() + "/.local/share/applications/open-url.desktop")) remove(getHome() + "/.local/share/applications/open-url.desktop");

//            /* Try and open a file for output */
//            QString outputFilename = getHome() + "/.local/share/applications/open-url.desktop";
//            QFile outputFile(outputFilename);
//            outputFile.open(QIODevice::WriteOnly);

//            /* Check it opened OK */
//            if(!outputFile.isOpen()){
//                qDebug() << "Error, unable to open" << outputFilename << "for output";
//                return 1;
//            }

//            /* Point a QTextStream object at the file */
//            QTextStream outStream(&outputFile);

//            /* Write the line to the file */
//            outStream << "[Desktop Entry]\n";
//            outStream << "Type=Application\n";
//            outStream << "Name=Browser\n";
//            outStream << "NoDisplay=true\n";
//            outStream << "NotShowIn=X-MeeGo;\n";
//            outStream << "MimeType=text/html;x-maemo-urischeme/http;x-maemo-urischeme/https;\n";
//            outStream << "Exec=" + execLine + "\n";

//            /* Close the file */
//            outputFile.close();
//            return 0;
//        }
        // Default Browser - open-url.desktop

        //[Desktop Entry]
        //Type=Application
        //Name=Browser
        //NotShowIn=X-MeeGo;
        //MimeType=text/html;x-maemo-urischeme/http;x-maemo-urischeme/https;
        //Exec=/usr/bin/harbour-webcat '%U'

        int setMime(const QString &mimeType, const QString &desktopFile)
        {
            QString desktopAction = desktopFile.section(".desktop", 0, 0);
            if (desktopAction.startsWith("harbour-webcat")) {
                desktopAction = "harbour-webcat-open-url";
            } else if (desktopAction == "sailfish-browser") {
                desktopAction = "open-url";
            } else {
                QList<ContentAction::Action> actionList = ContentAction::actionsForMime(mimeType);
                foreach (ContentAction::Action action, actionList) {
                    if (action.name().startsWith(desktopAction))// jolla apps use desktopAction-openfile/-openurl/-playvideostream mime handlers
                        desktopAction = action.name();
                    break;
                }
            }

            ContentAction::setMimeDefault(mimeType, desktopAction);

            return 0;
        }

        QString actionForMime(const QString &mimeType)
        {
            return ContentAction::defaultActionForMime(mimeType).name();
        }

        int openFileWith(const QString &application, const QString &url)
        {
            QProcess openApp;
            openApp.startDetached(application + " " + url);
            return 0;
        }
};


#endif // HELPER_HPP
