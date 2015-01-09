import QtQuick 2.0


Grid {
    id: pixelGrid

    width: parent.width
    height: parent.height

    columns: 12
    rows: 12


    Component {
        id: pixelComponent

        Rectangle {
            id: rectangle

            height: pixelGrid.height / pixelGrid.rows
            width: pixelGrid.width / pixelGrid.columns
        }
    }


    Component.onCompleted: {
        for(var x = 0; x < pixelGrid.columns; x++)
            for(var y = 0; y < pixelGrid.rows; y++)
            {
                var newPixel = pixelComponent.createObject(pixelGrid)
            }

        randomize()
    }


    function getColor(x, y)
    {
        return pixelGrid.children[y * pixelGrid.columns + x].color
    }


    function randomize() {
        var colors = ["blue", "cyan", "green", "yellow", "red", "pink"]

        for(var i = 0; i < pixelGrid.children.length; i++)
            pixelGrid.children[i].color = colors[Math.floor(colors.length * Math.random())]
    }


    function fillRecursive(x, y, oldcolor, newcolor, depth)
    {
        console.log(x + "-" + y + " " + oldcolor + " " + newcolor + " " + getColor(x, y))

        if(getColor(x, y) === oldcolor)
        {
            pixelGrid.children[y * pixelGrid.columns + x].color = newcolor

            // Left
            if(x > 0 && getColor(x - 1, y) === oldcolor)
                fillRecursive(x - 1, y, oldcolor, newcolor)

            // Right
            if(x < pixelGrid.columns - 1 && getColor(x + 1, y) === oldcolor)
                fillRecursive(x + 1, y, oldcolor, newcolor)

            // Top
            if(y > 0 && getColor(x, y - 1) === oldcolor)
                fillRecursive(x, y - 1, oldcolor, newcolor)

            // Bottom
            if(y < pixelGrid.rows - 1 && getColor(x, y + 1) === oldcolor)
                fillRecursive(x, y + 1, oldcolor, newcolor)
        }
    }


    function fill(newcolor) {
        var oldcolor = getColor(0,0)

        fillRecursive(0, 0, oldcolor, newcolor)
    }
}
