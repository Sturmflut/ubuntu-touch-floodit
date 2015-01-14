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

    QtObject {
        id: constants

        property variant colors: [ "blue", "cyan", "green", "yellow", "red", "violet"]
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
                pixelGrid.setSize(12)
                pixelGrid.randomize()
            }


            /*!
                \brief Returns true if the whole board is grid is filled with the same color
             */
            function isFilled()
            {
                var checkColor = getColor(0, 0)

                for(var i = 1; i < pixelGrid.getNumPixels(); i++)
                    if(!Qt.colorEqual(pixelGrid.getColorAt(i), checkColor))
                        return false

                return true
            }


            /*!
                \brief Randomizes the colors on the grid
             */
            function randomize() {
                for(var i = 0; i < pixelGrid.getNumPixels(); i++)
                    pixelGrid.setColorAt(i, constants.colors[Math.floor(6 * Math.random())])
            }
        }


        Grid {
            id: buttonGrid
            columns: 6
            rows: 1
            width: parent.width
            height: parent.width / 6

            Repeater {
                model: constants.colors

                Rectangle {
                    width: parent.width / 6
                    height: parent.height

                    radius: parent.height / 2

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

                    pixelGrid.setSize(boardSizeSelector.model[boardSizeSelector.selectedIndex])
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
