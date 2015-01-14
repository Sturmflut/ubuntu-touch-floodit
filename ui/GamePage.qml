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


    Constants {
        id: constants
    }


    QtObject {
        id: internal

        property int currentStep: 0
        property int maximumStep: constants.maximumSteps[0]

        property int sizeIndex: 0

        property int colorIndex: 0

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


    function resetGame()
    {
        internal.currentStep = 0
        internal.gameRunning = true

        scoreLabel.text = i18n.tr("Step") + " " + internal.currentStep + " / " + internal.maximumStep

        pixelGrid.setSize(constants.boardSizes[internal.sizeIndex])
        pixelGrid.randomize()
    }


    Component {
        id: newGameDialog

        Dialog {
            id: dialogue

            title: i18n.tr("New Game")

            ListItem.ItemSelector {
                id: boardSizeSelector

                text: i18n.tr("Board Size")
                model: constants.boardSizes
                expanded: true

                Component.onCompleted: selectedIndex = internal.sizeIndex

                onSelectedIndexChanged: internal.sizeIndex = selectedIndex
            }


            Button {
                text: i18n.tr("Ok")

                onClicked: {
                    internal.maximumStep = constants.maximumSteps[boardSizeSelector.selectedIndex]

                    gamePage.resetGame()

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
                    internal.colorIndex = paletteSelector.selectedIndex
                    buttonGrid.model = constants.colors[paletteSelector.selectedIndex]

                    gamePage.resetGame()

                    PopupUtils.close(dialogue)
                }
            }
        }
    }


    WinDialog {
        id: winDialog
    }


    LoseDialog {
        id: loseDialog
    }
}
