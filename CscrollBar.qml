import QtQuick
import QtQuick.Controls
import QtQuick.Window

Rectangle{
    id:parent_
    width: 120
    height: 20
    transformOrigin: Item.TopLeft

    property double defaul:0
    property double stepSize:0.01
    property double position:0
    property int maxValue:100
    property int minValue:0
    property color valueback:Qt.rgba(0.9,0.9,0.9)
    property string text:""
    property int textsize:16
    property bool reset:false

    onStepSizeChanged: subscrollbar.stepSize=stepSize
    onPositionChanged: {
        text_show.text=Math.round(subscrollbar.position*(maxValue-minValue)+minValue)
        subscrollbar.position=position
    }
    onValuebackChanged: value.color=valueback
    onTextChanged: text_.text=text
    onTextsizeChanged: text_.font.pixelSize=textsize
    onResetChanged: {
        if(reset)
        {
            subscrollbar.width=150
            value.x=180
            reset_.visible=true
        }
    }

    Component.onCompleted: {
        text_show.text=Math.round(subscrollbar.position*maxValue)
    }

    Text{
        id:text_
        width: 30
        height:20
        text:""
        font.pixelSize: 16
        horizontalAlignment:Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    ScrollBar{
        x:30
        id:subscrollbar
        hoverEnabled: true
        active:hovered || pressed
        orientation:Qt.Horizontal
        height:20
        width: 170
        stepSize: 0.004
        snapMode: ScrollBar.SnapAlways
        onPositionChanged: parent_.position=subscrollbar.position
    }
    Rectangle{
        id:value
        x:200
        width: 40
        height: 20
        color:Qt.rgba(0.8,0.8,0.8)
        Text{
            anchors.fill: parent
            id:text_show
            text:"0"
            font.pixelSize: 18
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    Button{
        visible: false
        id:reset_
        x:220
        text: "R"
        width: 20
        height: 20
        onClicked: subscrollbar.position=defaul

    }
}
