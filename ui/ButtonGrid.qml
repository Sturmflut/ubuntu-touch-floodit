import QtQuick 2.0
import QtFeedback 5.0

import Ubuntu.Components 1.1

import QtMultimedia 5.0


Grid {
    id: buttonGrid

    columns: 6
    rows: 1

    width: parent.width
    height: parent.width / 6

    spacing: units.gu(1)

    property var model

    Repeater {
        id: buttonGridRepeater

        model: parent.model

        Rectangle {
            width: buttonGrid.width / 6 - units.gu(0.75)
            height: width
            radius: height

            color: modelData

            Image {
                anchors.fill: parent

                source: "bubble.svg"
            }


            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if(audio_vibrate)
                    {
                        touchAudio.play();
                        vibration.start();
                    }

                    buttonGrid.clicked(parent.color)
                }
            }
        }
    }

    HapticsEffect {
        id: vibration

        attackIntensity: 1.0
        attackTime: 100
        intensity: 1.0
        duration: 80
        fadeTime: 100
        fadeIntensity: 0.0
    }

    Audio {
        id: touchAudio
        source: "touch.wav"
    }

    signal clicked(color color)
}
