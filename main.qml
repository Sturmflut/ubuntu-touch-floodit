import QtQuick 2.0
import Ubuntu.Components 1.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.sturmflut.floodit"


    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(70)
    height: units.gu(100)

    Page {
        id: mainPage
        title: i18n.tr("Flood It")

        Column {
            spacing: units.gu(1)
            anchors {
                margins: units.gu(2)
                fill: parent
            }

            Row {
                id: statusRow
                width: parent.width

                Label {
                    id: statusLabel

                    width: parent.width - newButton.width

                    text: i18n.tr("Step") + " 0 / 22"
                }

                Button {
                    id: newButton

                    text: i18n.tr("New")

                    onClicked: {
                        pixelComponent.randomize()
                    }
                }
            }

            PixelComponent {
                id: pixelComponent

                width: parent.width
                height: parent.height - statusRow.height - buttonGrid.height
            }

            Grid {
                id: buttonGrid
                columns: 6
                rows: 1
                width: parent.width
                height: parent.width / 6

                Repeater {
                    model: ["blue", "cyan", "green", "yellow", "red", "pink"]

                    Rectangle {
                        width: parent.width / 6
                        height: parent.height

                        radius: parent.height / 2

                        color: modelData

                        MouseArea {
                            anchors.fill: parent
                            onClicked: pixelComponent.fill(color)
                        }
                    }
                }
            }
        }
    }
}
