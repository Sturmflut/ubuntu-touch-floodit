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

        property int sizeIndex: 0

        property int colorIndex: 0

        property bool gameRunning: true
    }

    QtObject {
        id: constants

        property variant colors: [
            [ "blue", "cyan", "green", "yellow", "red", "violet" ],
            [ "black", "grey", "lightgrey", "red", "orange", "yellow" ],
            [ "blue", "cyan", "black", "green", "yellow", "red" ]
        ]
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

                width: parent.width - filler.width - paletteButton.width - newButton.width

                text: i18n.tr("Step") + " 0 / 22"
            }


            Button {
                id: paletteButton
                text: ""

                iconName: "settings"

                width: height

                onClicked: {
                    PopupUtils.open(setupDialog)
                }
            }

            Item {
                id: filler
                height: parent.height
                width: height
            }

            Button {
                id: newButton

                iconName: "reload"

                width: height

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
                    pixelGrid.setColorAt(i, constants.colors[internal.colorIndex][Math.floor(6 * Math.random())])
            }
        }

        ButtonGrid {
            id: buttonGrid

            model: constants.colors[0]
        }
    }


    Component {
        id: newGameDialog

        Dialog {
            id: dialogue

            title: i18n.tr("New Game")

            ListItem.ItemSelector {
                id: boardSizeSelector

                text: i18n.tr("Board Size")
                model: [12, 17, 22]
                expanded: true

                Component.onCompleted: selectedIndex = internal.sizeIndex

                onSelectedIndexChanged: internal.sizeIndex = selectedIndex
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
        id: setupDialog

        Dialog {
            id: dialogue

            title: i18n.tr("Setup")

            OptionSelector {
                id: paletteSelector

                text: i18n.tr("Palette")
                model: constants.colors
                expanded: true

                delegate: colorListItemComponent

                Component.onCompleted: selectedIndex = internal.colorIndex
            }


            Component {
                id: colorListItemComponent

                OptionSelectorDelegate {
                    Grid {
                        columns: 6
                        rows: 1

                        anchors.fill: parent

                        Repeater {
                            height: parent.height

                            model: modelData

                            Rectangle {
                                color: modelData
                                width: parent.width / 6
                                height: width

                                radius: parent.height / 2
                            }
                        }
                    }
                }
            }


            Button {
                text: i18n.tr("Ok")

                onClicked: {
                    internal.currentStep = 0
                    internal.gameRunning = true
                    internal.colorIndex = paletteSelector.selectedIndex

                    scoreLabel.text = i18n.tr("Step") + " " + internal.currentStep + " / " + internal.maximumStep

                    buttonGridRepeater.model =constants.colors[paletteSelector.selectedIndex]
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
