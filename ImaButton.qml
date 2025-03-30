import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

Button {
    id: control
    property int radiusBg: 6
    property color colorBorder: enabled?(control.hovered?(danger? (control.down ? "#ff1600" : "#FF7070") : (control.down ? "#1677ff" : "#4096ff")):"#80808080"):Qt.rgba(0,0,0,0.45)
    property string contentDescription: text
    property string img:""
    property bool danger:false
    property string toolTipText

    width: implicitContentWidth + leftPadding + rightPadding
    height: implicitContentHeight + topPadding + bottomPadding
    padding: 2
    topPadding: 1
    bottomPadding: 1
    contentItem: Rectangle{
        scale: 0.5
        Image {
            id:img_
            anchors.centerIn:parent
            source: img
            width: parent.width>parent.height ? 2*parent.height : 2*parent.width
            height: width
            ColorOverlay{
                    anchors.fill: parent
                    color: enabled?(danger? (control.down ? "#ff1600" : "#FF7070") : (control.down ? "#1677ff" : "#4096ff")):Qt.rgba(0,0,0,0.45)
                    source: parent
                    visible: control.hovered ? true:false
                }
        }

    }

    background: Item {
        Rectangle {
            id: __bg
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            radius:control.radiusBg
            border.width: 1
            border.color: control.enabled ? control.colorBorder : "transparent"

            property real realWidth: parent.width
            property real realHeight: parent.height
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked();
    ToolTip{
        background: Rectangle{
            color: "white"
            anchors.fill: parent
            border.color: "black"
        }
        delay: 1000
        timeout: 10000
        visible: hovered
        contentItem: Text{
            text: toolTipText
            font.pixelSize: 12
        }
    }
}


