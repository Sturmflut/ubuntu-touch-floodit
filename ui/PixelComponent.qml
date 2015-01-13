import QtQuick 2.0

/*!
    \brief PixelGrid, the central game component
*/
Grid {
    id: pixelGrid

    width: parent.width
    height: parent.height

    columns: 12
    rows: 12


    /*!
        \brief a pixelComponent is a single colored pixel on the grid.
    */
    Component {
        id: pixelComponent

        Rectangle {
            id: rectangle

            property int colorIndex

            height: pixelGrid.height / pixelGrid.rows
            width: pixelGrid.width / pixelGrid.columns

            onColorIndexChanged: {
                var colors = getColors()

                color = colors[colorIndex]
            }

            Component.onCompleted: {
                var colors = getColors()

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

    function getColorIndex(x,y) {
        return pixelGrid.children[y * pixelGrid.columns + x].colorIndex;
    }


    function setColorIndex(x, y, newcolor) {
        pixelGrid.children[y * pixelGrid.columns + x].colorIndex = newcolor
    }


    function getColors() {
        return ["blue", "cyan", "green", "yellow", "red", "violet"];
    }


    /*
     * Randomize all pixel colors on the board.
     */
    function randomize() {
        for(var i = 0; i < pixelGrid.children.length; i++)
            pixelGrid.children[i].colorIndex = Math.floor(6 * Math.random())
    }


    function isFinished()
    {
        var checkColor = getColorIndex(0, 0)

        for(var i = 1; i < pixelGrid.columns * pixelGrid.rows; i++)
            if(pixelGrid.children[i].colorIndex !== checkColor)
            {
                console.log("false")
                return false
            }

        console.log("true")
        return true
    }


    function fillRecursive(x, y, oldcolor, newcolor, depth)
    {
        setColorIndex(x, y, newcolor)

        // Left
        if(x > 0 && getColorIndex(x - 1, y) === oldcolor)
            fillRecursive(x - 1, y, oldcolor, newcolor)

        // Right
        if(x < pixelGrid.columns - 1 && getColorIndex(x + 1, y) === oldcolor)
            fillRecursive(x + 1, y, oldcolor, newcolor)

        // Top
        if(y > 0 && getColorIndex(x, y - 1) === oldcolor)
            fillRecursive(x, y - 1, oldcolor, newcolor)

        // Bottom
        if(y < pixelGrid.rows - 1 && getColorIndex(x, y + 1) === oldcolor)
            fillRecursive(x, y + 1, oldcolor, newcolor)
    }


    function fill(newcolor) {
        var oldcolor = pixelGrid.children[0].colorIndex

        if(oldcolor !== newcolor)
            fillRecursive(0, 0, oldcolor, newcolor)
    }
}
