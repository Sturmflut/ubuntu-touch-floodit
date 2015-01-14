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

                onClicked: {
                    if(internal.gameRunning)
                    {
                        pixelGrid.fill(color)

                        internal.currentStep = internal.currentStep + 1
                        scoreLabel.text = i18n.tr("Step") + " " + internal.currentStep + " / " + internal.maximumStep

                        if(pixelGrid.isFilled())
                        {
                            PopupUtils.open(winDialog)
                            internal.gameRunning = false
                        }
                        else
                            if(internal.currentStep === internal.maximumStep)
                            {
                                PopupUtils.open(loseDialog)
                                internal.gameRunning = false
                            }
                    }
                }
            }
        }
    }
}
