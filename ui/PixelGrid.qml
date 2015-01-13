import QtQuick 2.0

import Ubuntu.Components 1.1

/*!
    \brief A quadratic grid of animated "pixels" (colored rectangles).
*/
Grid {
    id: pixelGrid

    width: parent.width
    height: parent.height

    columns: 0
    rows: columns


    /*!
        \brief A pixelComponent is a single colored "pixel" on the grid.
    */
    Component {
        id: pixelComponent

        Rectangle {
            id: rectangle

            height: pixelGrid.height / pixelGrid.rows
            width: pixelGrid.width / pixelGrid.columns

            property int colorIndex


            Behavior on color {
                ColorAnimation {
                    duration: UbuntuAnimation.FastDuration
                }
            }


            Component.onCompleted:  {
                var colors = getColors()
                color = colors[colorIndex]
            }


            onColorIndexChanged: {
                var colors = getColors()
                color = colors[colorIndex]
            }


            function getColorIndex() {
                return colorIndex
            }


            function setColorIndex(newIndex)
            {
                colorIndex = newIndex
            }
        }
    }


    /*!
        \brief Change the size of the grid.
     */
    function setGridSize(newSize) {
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


    /*!
        \brief Return the color index of a pixel
     */
    function getColorIndex(x, y) {
        return pixelGrid.children[y * pixelGrid.columns + x].getColorIndex();
    }


    /*!
        \brief Set the color index of a pixel
     */
    function setColorIndex(x, y, newcolor) {
        pixelGrid.children[y * pixelGrid.columns + x].setColorIndex(newcolor)
    }


    /*!
        \brief Return the current color list
     */
    function getColors() {
        return ["blue", "cyan", "green", "yellow", "red", "violet"];
    }


    /*!
        \brief Randomize all pixel colors on the board.
     */
    function randomize() {
        for(var i = 0; i < pixelGrid.children.length; i++)
            pixelGrid.children[i].setColorIndex(Math.floor(6 * Math.random()))
    }


    /*!
        \brief Returns true if the whole board is grid is filled with the same color
     */
    function isFinished()
    {
        var checkColor = getColorIndex(0, 0)

        for(var i = 1; i < pixelGrid.columns * pixelGrid.rows; i++)
            if(pixelGrid.children[i].getColorIndex() !== checkColor)
                return false

        return true
    }


    /*!
        \brief Recursive filling function
     */
    function fillRecursive(x, y, oldcolor, newcolor)
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


    /*!
        \brief Start in the upper left corner and recursively fill all
        adjacent pixels of the old color with the new color
     */
    function fill(newcolor) {
        var oldcolor = pixelGrid.children[0].getColorIndex()

        if(oldcolor !== newcolor)
            fillRecursive(0, 0, oldcolor, newcolor)
    }
}
