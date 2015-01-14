import QtQuick 2.0


QtObject {
    readonly property variant colors: [
        [ "blue", "cyan", "green", "yellow", "red", "violet" ],
        [ "black", "grey", "lightgrey", "red", "orange", "yellow" ],
        [ "blue", "cyan", "black", "green", "yellow", "red" ]
    ]

    readonly property variant boardSizes: [12, 17, 22]
    readonly property variant maximumSteps: [22, 30, 36]
}
