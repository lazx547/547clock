import QtQuick
import QtQuick.Controls
import QtQuick.Window
// import GFile 1.2

ApplicationWindow {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint|Qt.Window
    width: 140
    height: 45
    color: "white"
    property string s:"hh:mm:ss"
    property bool can:false
    property string file_q_source

    MouseArea{
        z:115678
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton |Qt.MiddleButton
        onClicked: (mouse)=>{
                       if(mouse.button === Qt.LeftButton && can_tap.checked)
                       {
                           if(s=="hh:mm:ss")
                           s="hh:mm"
                           else if(s=="hh:mm")
                           s="hh:mm:ss"
                           textDateTime.text = Qt.formatDateTime(new Date(), s);
                       }
                       else if(mouse.button===Qt.MiddleButton && can_pau.checked)
                       {
                           timer.running=!timer.running
                           textDateTime.text = Qt.formatDateTime(new Date(), s);
                       }
                       else if(mouse.button===Qt.RightButton)
                       {
                           yjcd.x=mouseX+window.x
                           yjcd.y=mouseY+window.y
                           yjcd.visible=true
                       }


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
                         if(window.width>=10){
                             win.scale-=0.1
                             window.width=140*win.scale
                             window.height=50*win.scale
                         }
                     }
                     // file_q.source=file_q_source+"/w.1"
                     // file_q.write(window.width)
                     // file_q.source=file_q_source+"/h.1"
                     // file_q.write(window.height)
                 }
    }

    Rectangle {
        id:win
        color: "#00000000"
        scale: 1
        Item {
            anchors.fill: parent
            //显示
            Text{
                id: textDateTime
                text: Qt.formatDateTime(new Date(), s);
                font.pixelSize: 35
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
        anchors.fill: parent
        DragHandler {
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active)
                {
                    window.startSystemMove()
                    // file_q.source=file_q_source+"/x.1"
                    // file_q.write(window.x)
                    // file_q.source=file_q_source+"/y.1"
                    // file_q.write(window.y)
                }
            }
        }
    }

    // GFile{
    //     id:file_q
    // }
    // Component.onCompleted: {
    //     file_q_source="C:/Users/"+file_q.getUser()+"/AppData/Local/547clock"
    //     file_q.create(file_q_source)
    //     file_q.source=file_q_source+"/is.1"
    //     if(file_q.is(file_q.source))
    //     {

    //         file_q.source=file_q_source+"/x.1"
    //         window.x=Number(file_q.read())
    //         file_q.source=file_q_source+"/y.1"
    //         window.y=Number(file_q.read())
    //         file_q.source=file_q_source+"/w.1"
    //         window.width=Number(file_q.read())
    //         file_q.source=file_q_source+"/h.1"
    //         window.y=Number(file_q.read())
    //     }
    //     else
    //     {
    //         file_q.write("true")
    //         file_q.source=file_q_source+"/x.1"
    //         file_q.write(window.x)
    //         file_q.source=file_q_source+"/y.1"
    //         file_q.write(window.y)
    //         file_q.source=file_q_source+"/w.1"
    //         file_q.write(window.width)
    //         file_q.source=file_q_source+"/h.1"
    //         file_q.write(window.height)
    //     }
    // }

    Window{
        id:yjcd
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 100
        height: 150
        onActiveFocusItemChanged: {
            if(!activeFocusItem)
                visible=false
        }
        Button{
            width: 100
            height: 25
            text: "关闭"
            onClicked:
            {
                // file_q.source=file_q_source+"/x.1"
                // file_q.write(window.x.toString())
                // file_q.source=file_q_source+"/y.1"
                // file_q.write(window.y.toString())
                // file_q.source=file_q_source+"/w.1"
                // file_q.write(window.width.toString())
                // file_q.source=file_q_source+"/h.1"
                // file_q.write(window.height.toString())
                Qt.exit(0)
            }
        }
        CheckBox{
            y:25
            width: 100
            height: 30
            text: "显示在最上层"
            checked: true
            onCheckedChanged: {
                if(!checked)
                    window.flags=Qt.FramelessWindowHint
                else
                    window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                yjcd.visible=false
            }
        }
        CheckBox{
            id:can_pau
            y:45
            width: 100
            height: 30
            text: "允许暂停"
            checked: true
            onCheckedChanged: {
                yjcd.visible=false
            }
        }
        CheckBox{
            id:can_tap
            y:65
            width: 100
            height: 30
            text: "允许修改显示模式"
            font.pixelSize: 10
            checked: true
            onCheckedChanged: {
                yjcd.visible=false
            }
        }
        Button{
            y:90
            width: 100
            height: 25
            text: "浅色模式"
            onClicked:  {
                if(text==="浅色模式")
                {
                    text="深色模式"
                    win.color="#000"
                    textDateTime.color="white"
                }
                else
                {
                    text="浅色模式"
                    win.color="white"
                    textDateTime.color="#000"
                }
                yjcd.visible=false
            }
        }
        Text {
            y:115
            z:1
            text: "透明度"
        }
        ScrollBar{
            y:130
            z:0
            id:sb
            onPositionChanged: {
                window.opacity=position*0.9+0.1
            }
            position: 1
            hoverEnabled: true
            active:hovered || pressed
            orientation:Qt.Horizontal
            width: 100
            stepSize: 0.01
            snapMode: ScrollBar.SnapAlways
        }
    }
}

