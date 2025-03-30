import QtQuick
import QtQuick.Controls

Item {
    property var window
    Cbutton{
        id:up
        width: 25
        height: 25
        x:0
        rotation: 90
        text: "<"
        onClicked:
        {
            window.y-=1
        }
        toolTipText: "窗口上移一单位"
        radiusBg: 0
    }
    Cbutton{
        id:down
        width: 25
        height: 25
        rotation: 90
        x:25
        text: ">"
        onClicked:
        {
            window.y+=1
        }
        toolTipText: "窗口下移一单位"
        radiusBg: 0
    }
    Cbutton{
        id:left
        width: 25
        height: 25
        x:50
        text: "<"
        onClicked:
        {
            window.x-=1
        }
        toolTipText: "窗口左移一单位"
        radiusBg: 0
    }
    Cbutton{
        id:right
        width: 25
        height: 25
        x:75
        text: ">"
        onClicked:
        {
            window.x+=1
        }
        toolTipText: "窗口右移一单位"
        radiusBg: 0
    }
}
