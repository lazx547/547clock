import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    width: 140
    height: 50
    color: "white"
    property string s:"hh:mm:ss"
    MouseArea{
        z:115678
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton |Qt.MiddleButton
        onClicked: (mouse)=>{
                       if(mouse.button === Qt.LeftButton)
                       {
                           if(s=="hh:mm:ss")
                           s="hh:mm"
                           else if(s=="hh:mm")
                           s="hh:mm:ss"
                           textDateTime.text = Qt.formatDateTime(new Date(), s);
                       }
                       else if(mouse.button===Qt.MiddleButton)
                       {
                           timer.running=!timer.running
                           textDateTime.text = Qt.formatDateTime(new Date(), s);
                       }
                       else if(mouse.button===Qt.RightButton)
                       m.popup()
                   }
        onWheel: (wheel)=>{
                     if(wheel.angleDelta.y>0)
                     {
                         win.scale+=0.1
                         window.width=140*win.scale
                         window.height=50*win.scale
                     }
                     else
                     {
                         win.scale-=0.1
                         window.width=140*win.scale
                         window.height=50*win.scale
                     }
                     if(win.scale<1)

                         m.scale=win.scale

                     else
                         m.scale=1
                 }
    }

    Rectangle {
        id:win
        scale: 1
        Rectangle{
            anchors.fill: parent

            Item {
                anchors.fill: parent

                //显示
                Text{
                    id: textDateTime
                    text: Qt.formatDateTime(new Date(), s);
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }

                //定时器
                Timer{
                    id: timer
                    interval: 1000 //间隔(单位毫秒):1000毫秒=1秒
                    running: true
                    repeat: true //重复
                    onTriggered:{
                        textDateTime.text = Qt.formatDateTime(new Date(), s);
                    }
                }
            }
        }
        anchors.fill: parent
        DragHandler {
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: if (active) { window.startSystemMove() }
        }
    }

    Menu{
        width: 100
        height:42
        id:m
        scale: 1
        MenuItem{
            width: 100
            height: 20
            text: "关闭"
            onTriggered: Qt.exit(0)
        }
        MenuItem{
            width: 100
            height: 20
            CheckBox{
                width: 100
                height: 20
                text: "显示在最上层"
                checked: true
                onCheckedChanged: {
                    if(!checked)
                        window.flags=Qt.FramelessWindowHint
                    else
                        window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                }
            }
        }
    }
}
