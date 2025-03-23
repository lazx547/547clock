import QtQuick
import QtQuick.Controls

Item {
    property var window
    DelButton{
        id:up
        width: 30
        height: 30
        x:0
        rotation: 90
        text: "<"
        onClicked:
        {
            window.y-=1
        }
    }
    DelButton{
        id:down
        width: 30
        height: 30
        rotation: 90
        x:30
        text: ">"
        onClicked:
        {
            window.y+=1
        }
    }
    DelButton{
        id:left
        width: 30
        height: 30
        x:60
        text: "<"
        onClicked:
        {
            window.x-=1
        }
    }
    DelButton{
        id:right
        width: 30
        height: 30
        x:90
        text: ">"
        onClicked:
        {
            window.x+=1
        }
    }
}
