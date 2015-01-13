import QtQuick 2.0

import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

/*!
    \brief A Page implementing the actual "Flood It" game.
*/
Page {
    id: gamePage
    title: i18n.tr("Flood It")

    QtObject {
        id: internal

        property int currentStep: 0
        property int maximumStep: 22

        property bool gameRunning: true
    }


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
                id: scoreLabel

                width: parent.width - newButton.width

                text: i18n.tr("Step") + " 0 / 22"
            }

            Button {
                id: newButton

                text: i18n.tr("New")

                onClicked: {
                    PopupUtils.open(newGameDialog)
                }
            }
        }


        PixelGrid {
            id: pixelGrid

            width: parent.width
            height: parent.height - statusRow.height - buttonGrid.height


            Component.onCompleted: {
                pixelGrid.setGridSize(12)
                pixelGrid.randomize()
            }
        }


        Grid {
            id: buttonGrid
            columns: 6
            rows: 1
            width: parent.width
            height: parent.width / 6

            Repeater {
                model: [0, 1, 2, 3, 4, 5]

                Rectangle {
                    width: parent.width / 6
                    height: parent.height

                    radius: parent.height / 2

                    property int colorIndex: modelData

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if(internal.gameRunning)
                            {
                                pixelGrid.fill(colorIndex)

                                internal.currentStep = internal.currentStep + 1
                                scoreLabel.text = i18n.tr("Step") + " " + internal.currentStep + " / " + internal.maximumStep

                                if(pixelGrid.isFinished())
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

                    Component.onCompleted: {
                        var colors = pixelGrid.getColors()
                        color = colors[colorIndex]
                    }
                }
            }
        }
    }


    Component {
        id: newGameDialog

        Dialog {
            id: dialogue

            title: i18n.tr("New Game")

            property int boardSize

            OptionSelector {
                id: boardSizeSelector

                text: i18n.tr("Board Size")
                model: [12, 17, 22]
            }

            Button {
                text: i18n.tr("Ok")
                onClicked: {
                    var maxSteps = [22, 30, 36]

                    internal.maximumStep = maxSteps[boardSizeSelector.selectedIndex]

                    internal.currentStep = 0
                    internal.gameRunning = true

                    scoreLabel.text = i18n.tr("Step") + " " + internal.currentStep + " / " + internal.maximumStep

                    pixelGrid.setGridSize(boardSizeSelector.model[boardSizeSelector.selectedIndex])
                    pixelGrid.randomize()

                    PopupUtils.close(dialogue)
                }
            }
        }
    }


    Component {
        id: winDialog

        Dialog {
            id: dialogue

            title: i18n.tr("Win!")
            text: i18n.tr("Congratulations!")

            Button {
                text: i18n.tr("Ok")
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }


    Component {
        id: loseDialog

        Dialog {
            id: dialogue

            title: i18n.tr("You lose!")
            text: i18n.tr("Oh no!")

            Button {
                text: i18n.tr("Ok")
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }
}
