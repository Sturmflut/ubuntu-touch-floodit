import QtQuick 2.0

import Ubuntu.Components 1.1

import "ui"

/*!
    \brief MainView with a Label and Button elements.
*/
MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    applicationName: "com.ubuntu.developer.sturmflut.floodit"

    useDeprecatedToolbar: false

    width: units.gu(70)
    height: units.gu(100)


    GamePage {
    }
}
