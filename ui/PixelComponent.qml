import QtQuick 2.0

import Ubuntu.Components 1.1

/*!
    \brief PixelGrid, the central game component
*/
Grid {
    id: pixelGrid

    width: parent.width
    height: parent.height

    columns: 0
    rows: columns


    /*!
        \brief a pixelComponent is a single colored pixel on the grid.
    */
    Component {
        id: pixelComponent

        Rectangle {
            id: rectangle

            height: pixelGrid.height / pixelGrid.rows
            width: pixelGrid.width / pixelGrid.columns

            color: "white"

            property int colorIndex


            PropertyAnimation {
                id: colorAnimation
                target: rectangle
                properties: "color"

                duration: UbuntuAnimation.FastDuration
            }


            function getColorIndex() {
                return colorIndex
            }


            function setColorIndex(newIndex)
            {
                var colors = getColors()

                colorIndex = newIndex

                colorAnimation.to = colors[newIndex]
                colorAnimation.start()
            }
        }
    }


    function setBoardSize(newSize) {
        // If the size really changed
        if(newSize !== pixelGrid.columns)
        {
            // Update grid size
            pixelGrid.columns = newSize
            pixelGrid.rows = newSize

            // Clear old pixels
            pixelGrid.children = ""

            // Create pixels
            for(var i = 0; i < pixelGrid.columns * pixelGrid.rows; i++)
                var newPixel = pixelComponent.createObject(pixelGrid)
        }
    }


    function getColorIndex(x, y) {
        return pixelGrid.children[y * pixelGrid.columns + x].getColorIndex();
    }


    function setColorIndex(x, y, newcolor) {
        pixelGrid.children[y * pixelGrid.columns + x].setColorIndex(newcolor)
    }


    function getColors() {
        return ["blue", "cyan", "green", "yellow", "red", "violet"];
    }


    /*
     * Randomize all pixel colors on the board.
     */
    function randomize() {
        for(var i = 0; i < pixelGrid.children.length; i++)
            pixelGrid.children[i].setColorIndex(Math.floor(6 * Math.random()))
    }


    function isFinished()
    {
        var checkColor = getColorIndex(0, 0)

        for(var i = 1; i < pixelGrid.columns * pixelGrid.rows; i++)
            if(pixelGrid.children[i].getColorIndex() !== checkColor)
                return false

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
        var oldcolor = pixelGrid.children[0].getColorIndex()

        if(oldcolor !== newcolor)
            fillRecursive(0, 0, oldcolor, newcolor)
    }
}
