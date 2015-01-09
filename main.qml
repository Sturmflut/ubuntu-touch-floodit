import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

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

        property int currentScore
        property bool gameRunning

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
                        pixelComponent.randomize()

                        mainPage.currentScore = 0
                        mainPage.gameRunning = true
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
                    model: [0, 1, 2, 3, 4, 5]

                    Rectangle {
                        width: parent.width / 6
                        height: parent.height

                        radius: parent.height / 2

                        property int colorIndex: modelData

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                if(mainPage.gameRunning)
                                {
                                    pixelComponent.fill(colorIndex)

                                    mainPage.currentScore = mainPage.currentScore + 1

                                    if(pixelComponent.gameFinished)
                                    {
                                        PopupUtils.open(winDialog)
                                        mainPage.gameRunning = false
                                    }

                                    if(mainPage.currentScore === 22)
                                    {
                                        PopupUtils.open(loseDialog)
                                        mainPage.gameRunning = false
                                    }
                                }
                            }
                        }

                        Component.onCompleted: {
                            var colors = ["blue", "cyan", "green", "yellow", "red", "pink"]

                            color = colors[colorIndex]
                        }
                    }
                }
            }
        }


        Component.onCompleted: {
            currentScore = 0
            gameRunning = true
        }


        onCurrentScoreChanged: {
            scoreLabel.text = i18n.tr("Step") + " " + currentScore + " / 22"
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
