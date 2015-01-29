import QtQuick 2.0

import Ubuntu.Components 1.1


Grid {
    id: buttonGrid
    columns: 6
    rows: 1
    width: parent.width
    height: parent.width / 6

    property var model

    Repeater {
        id: buttonGridRepeater

        model: parent.model

        Rectangle {
            width: parent.width / 6
            height: width
            radius: height

            gradient: Gradient {
                GradientStop { position: 0.0; color: modelData }
                GradientStop { position: 0.15; color: Qt.lighter(modelData, 1.4) }
                GradientStop { position: 0.5; color: Qt.darker(modelData, 1.4) }
                GradientStop { position: 1.0; color: modelData }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: buttonGrid.clicked(parent.color)
            }
        }
    }

    signal clicked(color color)
}
