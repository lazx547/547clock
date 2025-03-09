import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    width: 140
    height: 33
    color: "#00000000"
    property string s:"hh:mm:ss"
    property bool can:false
    property bool colorset:false

    MouseArea{
        z:115678
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton |Qt.MiddleButton
        onClicked: (mouse)=>{
                       if(mouse.button===Qt.MiddleButton && can_pau.checked  &&!can_s.checked)
                       {
                           timer.running=!timer.running
                           textDateTime.text = Qt.formatDateTime(new Date(), s);
                       }
                       else if(mouse.button===Qt.RightButton)
                       {
                           if(cd.y===10)
                           {
                               yjcd.x=mouseX+window.x
                               yjcd.y=mouseY+window.y
                           }
                            else
                            {
                               yjcd.x=mouseX+window.x
                               yjcd.y=mouseY+window.y
                               yjcd.y-=yjcd.height
                           }

                           yjcd.visible=true
                       }


                   }
        onWheel: (wheel)=>{
                     if(!can_s.checked)
                     {
                         if(wheel.angleDelta.y>0)
                         {
                             win.scale+=0.1
                             window.width=140*win.scale
                             window.height=33*win.scale
                         }
                         else
                         {
                             if(window.width>=30){
                                 win.scale-=0.1
                                 window.width=140*win.scale
                                 window.height=33*win.scale
                             }
                         }
                         sb2.position=(win.scale-0.1)/8
                     }
                 }
    }

    Rectangle{
        id:winm
        color: "white"
        z:-2
        anchors.fill:parent
    }
    Rectangle{
        id:winn
        color: "#00000000"
        border.color: "#000"
        z:-1
        anchors.fill:parent
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
        onScaleChanged: winn.border.width=f_r.position*win.scale*18
        anchors.fill: parent
        DragHandler {
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active &&!can_s.checked)
                {
                    window.startSystemMove()
                }
            }
        }
    }
    Window{
        id:yjcd
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 100
        height: 307
        onActiveFocusItemChanged: {
            if(!activeFocusItem)
                visible=false
        }
        Item{
            id:move
            Component.onCompleted: {
                y=yjcd.height-15
            }

            property bool above:false
            Button{
                id:ss
                width: 15
                height: 15
                text: "→"
                rotation: 90
                font.bold: true
                onClicked:
                {
                    if(!move.above)
                    {
                        yjcd.y+=yjcd.height
                        cd.y=15
                        move.y=0
                        move.above=true
                        rotation=270
                    }
                    else
                    {
                        yjcd.y-=yjcd.height
                        cd.y=0
                        move.y=yjcd.height-15
                        move.above=false
                        rotation=90
                    }
                }
            }
            Button{
                id:up
                width: 15
                height: 15
                x:20
                rotation: 90
                text: "<"
                onClicked:
                {
                    window.y-=1
                }
            }
            Button{
                id:down
                width: 15
                height: 15
                rotation: 90
                x:40
                text: ">"
                onClicked:
                {
                    window.y+=1
                }
            }
            Button{
                id:left
                width: 15
                height: 15
                x:60
                text: "<"
                onClicked:
                {
                    window.x-=1
                }
            }
            Button{
                id:right
                width: 15
                height: 15
                x:80
                text: ">"
                onClicked:
                {
                    window.x+=1
                }
            }
        }
        Item{
            id:cd
            Button{
                id:close_
                width: 100
                height: 15
                text: "关闭"
                font.pixelSize: 10
                onClicked:
                {
                    Qt.exit(0)
                }
            }
            Item{
                id:checks
                y:15
                width: 60
                CheckBox{
                    id:top_
                    width: 100
                    height: 15
                    text: "显示在最上层"
                    font.pixelSize: 10
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
                    width: 100
                    height: 15
                    y:15
                    font.pixelSize: 10
                    text: "允许暂停"
                    checked: true
                    onCheckedChanged: {
                        yjcd.visible=false
                    }
                }
                CheckBox{
                    id:can_s
                    width: 100
                    height: 15
                    y:30
                    text: "锁定"
                    font.pixelSize: 10
                    checked: false
                    onCheckedChanged: {
                        yjcd.visible=false
                    }
                }
                Button{
                    width: 100
                    height: 15
                    y:45
                    text: "显示 h:m:s"
                    font.pixelSize: 10
                    onClicked:  {
                        if(text==="显示 h:m:s")
                        {
                            text="显示 h:m"
                            s="hh:mm"
                            textDateTime.text = Qt.formatDateTime(new Date(), s);
                        }
                        else
                        {
                            text="显示 h:m:s"
                            s="hh:mm:ss"
                            textDateTime.text = Qt.formatDateTime(new Date(), s);
                        }
                        yjcd.visible=false
                    }
                }
            }
            Item{
                id:appea
                y:75
                Button{
                    width: 100
                    height: 15
                    text: "浅色模式"
                    font.pixelSize: 10
                    onClicked:  {
                        if(text==="浅色模式")
                        {
                            text="深色模式"
                            winm.color="#000"
                            textDateTime.color=colorset? textDateTime.color:"white"
                            winn.border.color="white"
                        }
                        else
                        {
                            text="浅色模式"
                            winm.color="white"
                            textDateTime.color=colorset? textDateTime.color:"#000"
                            winn.border.color="#000"
                        }
                        yjcd.visible=false
                    }
                }
                Text {
                    y:15
                    z:1
                    font.pixelSize: 10
                    text: "透明度"
                }
                ScrollBar{
                    scale: 0.667
                    y:20
                    z:0
                    id:sb
                    x:-25
                    onPositionChanged: {
                        window.opacity=position*0.95+0.05
                    }
                    position: 1
                    hoverEnabled: true
                    active:hovered || pressed
                    orientation:Qt.Horizontal
                    width: 150
                    stepSize: 0.01
                    snapMode: ScrollBar.SnapAlways
                }
                Text {
                    y:35
                    z:1
                    font.pixelSize: 10
                    text: "背景透明度"
                }
                ScrollBar{
                    scale: 0.667
                    y:40
                    z:0
                    x:-25
                    id:sb3
                    onPositionChanged: {
                        winm.opacity=position
                        if(winm.opacity===0)
                            winm.visible=false
                        else
                            winm.visible=true
                    }
                    position: 1
                    hoverEnabled: true
                    active:hovered || pressed
                    orientation:Qt.Horizontal
                    width: 150
                    stepSize: 0.01
                    snapMode: ScrollBar.SnapAlways
                }
                Text {
                    y:55
                    z:1
                    font.pixelSize: 10
                    text: "缩放"
                }
                ScrollBar{
                    scale: 0.667
                    y:60
                    x:-25
                    z:0
                    id:sb2
                    onPositionChanged: {
                        win.scale=position*8+0.1
                        window.width=140*win.scale
                        window.height=33*win.scale
                    }
                    position: 0.125
                    hoverEnabled: true
                    active:hovered || pressed
                    orientation:Qt.Horizontal
                    width: 150
                    stepSize: 0.001
                    snapMode: ScrollBar.SnapAlways
                }
                Item{
                    id:font_
                    y:75
                    Text{
                        text:"字体"
                        font.pixelSize: 10
                    }
                    Button{
                        text: "<"
                        rotation: 90
                        x:25
                        width: 15
                        height: 15
                        onClicked: {
                            textDateTime.font.pixelSize+=1
                        }

                    }
                    Button{
                        text: "<"
                        rotation: 270
                        x:40
                        width: 15
                        height: 15
                        onClicked: {
                            textDateTime.font.pixelSize-=1
                        }
                    }
                    CheckBox{
                        text: "加粗"
                        font.pixelSize: 10
                        height: 15
                        x:60
                        checked: false
                        onCheckedChanged: {
                            textDateTime.font.bold=checked
                        }
                    }
                }
                Item{
                    id:border_
                    y:90
                    Text{
                        text:"边框"
                        height: 15
                        font.pixelSize: 10
                    }
                    ScrollBar{
                        scale: 0.667
                        y:0
                        z:0
                        id:f_r
                        x:5
                        onPositionChanged: {
                            winn.border.width=position*win.scale*18
                        }
                        position: 0
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 110
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                }
                Text{
                    y:105
                    z:1
                    font.pixelSize: 10
                    text: "Width"
                }
                ScrollBar{
                    scale: 0.667
                    y:110
                    z:0
                    id:wid
                    x:-25
                    onPositionChanged: {
                        window.width=position*280*win.scale
                    }
                    position: 0.5
                    hoverEnabled: true
                    active:hovered || pressed
                    orientation:Qt.Horizontal
                    width: 150
                    stepSize: 0.01
                    snapMode: ScrollBar.SnapAlways
                }
                Text{
                    y:122
                    z:1
                    font.pixelSize: 10
                    text: "Height"
                }
                ScrollBar{
                    scale: 0.667
                    y:127
                    z:0
                    id:hei
                    x:-25
                    onPositionChanged: {
                        window.height=position*66*win.scale
                    }
                    position: 0.5
                    hoverEnabled: true
                    active:hovered || pressed
                    orientation:Qt.Horizontal
                    width: 150
                    stepSize: 0.01
                    snapMode: ScrollBar.SnapAlways
                }
                Button{
                    y:202
                    text:"源代码"
                    font.pixelSize: 10
                    width: 100
                    height: 15
                    onClicked: Qt.openUrlExternally("https://github.com/lazx547/547clock")
                }
                Item{
                    id:colo
                    y:142
                    Text{
                        text:"颜色"
                        font.pixelSize: 10
                    }
                    Text{
                        text:"R"
                        y:15
                        height: 15
                        font.pixelSize: 10
                    }
                    ScrollBar{
                        scale: 0.667
                        y:15
                        z:0
                        id:colo_r
                        x:-10
                        onPositionChanged: {
                            colorset=true
                            textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position6)
                        }
                        position: 0
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 130
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                    Text{
                        text:"G"
                        y:30
                        height: 15
                        font.pixelSize: 10
                    }
                    ScrollBar{
                        scale: 0.667
                        y:30
                        z:0
                        id:colo_g
                        x:-10
                        onPositionChanged: {
                            colorset=true
                            textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                        }
                        position: 0
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 130
                        stepSize: 0.004
                        snapMode: ScrollBar.SnapAlways
                    }
                    Text{
                        text:"R"
                        y:45
                        height: 15
                        font.pixelSize: 10
                    }
                    ScrollBar{
                        scale: 0.667
                        y:45
                        z:0
                        id:colo_b
                        x:-10
                        onPositionChanged: {
                            colorset=true
                            textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                        }
                        position: 0
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 130
                        stepSize: 0.004
                        snapMode: ScrollBar.SnapAlways
                    }
                }
            }
        }
    }
}

