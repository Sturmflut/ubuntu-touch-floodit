import QtQuick 2.0


Grid {
    id: pixelGrid

    width: parent.width
    height: parent.height

    columns: 12
    rows: 12

    property bool gameFinished: false


    Component {
        id: pixelComponent

        Rectangle {
            id: rectangle

            property int colorIndex

            height: pixelGrid.height / pixelGrid.rows
            width: pixelGrid.width / pixelGrid.columns

            onColorIndexChanged: {
                var colors = ["blue", "cyan", "green", "yellow", "red", "pink"]

                console.log("onColorIndexChanged " + colorIndex)
                color = colors[colorIndex]
            }

            Component.onCompleted: {
                var colors = ["blue", "cyan", "green", "yellow", "red", "pink"]

                console.log("onColorIndexChanged " + colorIndex)
                color = colors[colorIndex]
            }
        }
    }


    Component.onCompleted: {
        // Create pixels
        for(var i = 0; i < pixelGrid.columns * pixelGrid.rows; i++)
            var newPixel = pixelComponent.createObject(pixelGrid)

        // Randomize colors
        randomize()
    }


    /*
     * Randomize all pixel colors on the board.
     */
    function randomize() {
        for(var i = 0; i < pixelGrid.children.length; i++)
            pixelGrid.children[i].colorIndex = Math.floor(6 * Math.random())

        gameFinished = false
    }


    function checkFinished(newcolor)
    {
        for(var i = 0; i < pixelGrid.columns * pixelGrid.rows; i++)
            if(pixelGrid.children[i].colorIndex !== newcolor)
                return

        gameFinished = true
    }


    function fillRecursive(x, y, oldcolor, newcolor, depth)
    {
        console.log(x + "-" + y + " " + oldcolor + " " + newcolor + " " + pixelGrid.children[y * pixelGrid.columns + x].colorIndex)

        if(pixelGrid.children[y * pixelGrid.columns + x].colorIndex === oldcolor)
        {
            pixelGrid.children[y * pixelGrid.columns + x].colorIndex = newcolor

            // Left
            if(x > 0 && pixelGrid.children[y * pixelGrid.columns + (x - 1)].colorIndex === oldcolor)
                fillRecursive(x - 1, y, oldcolor, newcolor)

            // Right
            if(x < pixelGrid.columns - 1 && pixelGrid.children[y * pixelGrid.columns + (x + 1)].colorIndex === oldcolor)
                fillRecursive(x + 1, y, oldcolor, newcolor)

            // Top
            if(y > 0 && pixelGrid.children[(y - 1) * pixelGrid.columns + x].colorIndex === oldcolor)
                fillRecursive(x, y - 1, oldcolor, newcolor)

            // Bottom
            if(y < pixelGrid.rows - 1 && pixelGrid.children[(y + 1) * pixelGrid.columns + x].colorIndex === oldcolor)
                fillRecursive(x, y + 1, oldcolor, newcolor)
        }
    }


    function fill(newcolor) {
        var oldcolor = pixelGrid.children[0].colorIndex

        if(oldcolor !== newcolor)
        {
            fillRecursive(0, 0, oldcolor, newcolor)

            checkFinished(newcolor)
        }
    }
}
