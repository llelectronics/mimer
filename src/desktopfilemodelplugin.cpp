#include "desktopfilemodelplugin.h"
#include "desktopfilesortmodel.h"

#include <qqml.h>

void DesktopFileModelPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<DesktopFileSortModel>(uri, 1, 0, "DesktopFileSortModel");
}
