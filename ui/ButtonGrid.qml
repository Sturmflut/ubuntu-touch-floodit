import QtQuick 2.0


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

            color: modelData

            MouseArea {
                anchors.fill: parent

                onClicked: buttonGrid.clicked(parent.color)
            }
        }
    }

    signal clicked(color color)
}
