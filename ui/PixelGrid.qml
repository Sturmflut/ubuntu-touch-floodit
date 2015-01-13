import QtQuick 2.0

import Ubuntu.Components 1.1

/*!
    \brief A quadratic grid of animated "pixels" (colored rectangles)
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

            property color finalColor: color


            Behavior on color {
                ColorAnimation {
                    duration: UbuntuAnimation.FastDuration
                }
            }


            function getColor() {
                return Qt.lighter(finalColor, 1.0)
            }


            function setColor(newColor)
            {
                finalColor = Qt.lighter(newColor, 1.0)
                color = Qt.lighter(newColor, 1.0)
            }
        }
    }


    /*!
        \brief Change the size of the grid.
     */
    function setSize(newSize) {
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
        \brief Get the size of the grid.
     */
    function getSize() {
        return pixelGrid.columns
    }


    /*!
        \brief Get the number of pixels on the grid
     */
    function getNumPixels() {
        return pixelGrid.columns * pixelGrid.columns
    }


    /*!
        \brief Return the color index of the pixel at (x, y)
     */
    function getColor(x, y) {
        return getColorAt(y * getSize() + x)
    }


    /*!
        \brief Return the color index of pixel number n
     */
    function getColorAt(n) {
        return pixelGrid.children[n].getColor();
    }


    /*!
        \brief Set the color index of a pixel
     */
    function setColor(x, y, newcolor) {
        pixelGrid.setColorAt(y * getSize() + x, newcolor)
    }


    /*!
        \brief Set the color index of a pixel
     */
    function setColorAt(n, newcolor) {
        pixelGrid.children[n].setColor(newcolor)
    }


    /*!
        \brief Recursive filling function
     */
    function fillRecursive(x, y, newcolor, oldcolor, depth)
    {

        if(Qt.colorEqual(getColor(x, y), newcolor) === false)
        {
            setColor(x, y, newcolor)

            // Left
            if(x > 0 && Qt.colorEqual(getColor(x - 1, y), oldcolor) === true)
                fillRecursive(x - 1, y, newcolor, oldcolor, depth + 1)

            // Right
            if(x < getSize() - 1 && Qt.colorEqual(getColor(x + 1, y), oldcolor) === true)
                fillRecursive(x + 1, y, newcolor, oldcolor, depth + 1)

            // Top
            if(y > 0 && Qt.colorEqual(getColor(x, y - 1), oldcolor) === true)
                fillRecursive(x, y - 1, newcolor, oldcolor, depth + 1)

            // Bottom
            if(y < getSize() - 1 && Qt.colorEqual(getColor(x, y + 1), oldcolor) === true)
                fillRecursive(x, y + 1, newcolor, oldcolor, depth + 1)
        }
    }


    /*!
        \brief Start in the upper left corner and recursively fill all
        adjacent pixels of the old color with the new color
     */
    function fill(newcolor) {
        var oldcolor = getColorAt(0)

        if(Qt.colorEqual(oldcolor, newcolor) === false)
            fillRecursive(0, 0, newcolor, oldcolor, 0)
    }
}
