import QtQuick
import QtQuick.Controls
import QtQuick.Window
import GFile 1.2

Window {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    width: 140
    height: 33
    color: "#00000000"
    property string s:"hh:mm:ss"
    property int winw:140
    property int winh:33
    //property int cwinw:140
    property string file_q_source

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
                           if(cd.y===15)
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
                             window.width=winw*win.scale
                             window.height=winh*win.scale
                         }
                         else
                         {
                             if(window.width>=30){
                                 win.scale-=0.1
                                 window.width=winw*win.scale
                                 window.height=winh*win.scale
                             }
                         }
                         sb2.position=(win.scale-0.1)/8
                     }
                 }
    }

    Rectangle{//背景
        id:winm
        color: "white"
        z:-2
        anchors.fill:parent
        radius: 0
    }
    Rectangle{//边框
        id:winn
        color: "#00000000"
        border.color: "#000"
        border.width: 1.8
        z:-1
        anchors.fill:parent
        radius: 0
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
                interval: 100 //间隔(单位毫秒):1000毫秒=1秒
                running: false
                repeat: true //重复
                onTriggered:{
                    textDateTime.text = Qt.formatDateTime(new Date(), s);
                }
            }
            Timer{
                id:timer_set
                interval: 1
                property bool f:true
                running: true
                repeat: true
                onTriggered:{
                    if(f)
                    {
                        textDateTime.text= Qt.formatDateTime(new Date(), s);
                        f=false
                    }
                    else
                    {
                        if(textDateTime.text==Qt.formatDateTime(new Date(), s))
                        {
                            timer.running=true
                            running=false
                        }
                    }
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
    GFile{
        id:file_q
    }
    Component.onCompleted: {
        var a=0
        file_q_source="."
        file_q.create(file_q_source)
        file_q.source=file_q_source+"/is.1"
        if(file_q.is(file_q.source))
        {
            if(file_q.read()==="true")
            {
                file_q.source=file_q_source+"/r1.1"
                colo_r.position=Number(file_q.read())
                file_q.source=file_q_source+"/g1.1"
                colo_b.position=Number(file_q.read())
                file_q.source=file_q_source+"/b1.1"
                colo_g.position=Number(file_q.read())
                file_q.source=file_q_source+"/r2.1"
                colo_br.position=Number(file_q.read())
                file_q.source=file_q_source+"/g2.1"
                colo_bb.position=Number(file_q.read())
                file_q.source=file_q_source+"/b2.1"
                colo_bg.position=Number(file_q.read())
                file_q.source=file_q_source+"/top.1"
                top_.checked=file_q.read()=="true"? true:false
                file_q.source=file_q_source+"/h1.1"
                sb.position=Number(file_q.read())
                file_q.source=file_q_source+"/h2.1"
                sb3.position=Number(file_q.read())
                file_q.source=file_q_source+"/fs.1"
                textDateTime.font.pixelSize=Number(file_q.read())
                file_q.source=file_q_source+"/bw.1"
                f_r.position=Number(file_q.read())
                file_q.source=file_q_source+"/fb.1"
                f_b.checked=file_q.read()=="true"? true:false
                file_q.source=file_q_source+"/ra.1"
                rad_.position=Number(file_q.read())/*
                file_q.source=file_q_source+"/w.1"
                winw=Number(file_q.read())
                file_q.source=file_q_source+"/h.1"
                winh=Number(file_q.read())*/
                a=1
            }
        }
        if(a==0)
        {
            file_q.write("true")
            file_q.source=file_q_source+"/r1.1"
            file_q.write(colo_r.position)
            file_q.source=file_q_source+"/g1.1"
            file_q.write(colo_g.position)
            file_q.source=file_q_source+"/b1.1"
            file_q.write(colo_b.position)
            file_q.source=file_q_source+"/r2.1"
            file_q.write(colo_br.position)
            file_q.source=file_q_source+"/b2.1"
            file_q.write(colo_bg.position)
            file_q.source=file_q_source+"/g2.1"
            file_q.write(colo_bb.position)
            file_q.source=file_q_source+"/top.1"
            file_q.write(top_.checked)
            file_q.source=file_q_source+"/h1.1"
            file_q.write(sb.position)
            file_q.source=file_q_source+"/h2.1"
            file_q.write(sb3.position)
            file_q.source=file_q_source+"/fs.1"
            file_q.write(textDateTime.font.pixelSize)
            file_q.source=file_q_source+"/bw.1"
            file_q.write(f_r.position)
            file_q.source=file_q_source+"/fb.1"
            file_q.write(f_b.checked)
            file_q.source=file_q_source+"/ra.1"
            file_q.write(rad_.position)/*
            file_q.source=file_q_source+"/w.1"
            file_q.write(winw)
            file_q.source=file_q_source+"/h.1"
            file_q.write(winh)*/
        }
    }
    Window{
        id:yjcd
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 100
        height: 310
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
                id:close_
                x:15
                width: 25
                height: 15
                text: "关闭"
                font.pixelSize: 8
                onClicked:
                {
                    file_q.source=file_q_source+"/r1.1"
                    file_q.write(colo_r.position)
                    file_q.source=file_q_source+"/b1.1"
                    file_q.write(colo_g.position)
                    file_q.source=file_q_source+"/g1.1"
                    file_q.write(colo_b.position)
                    file_q.source=file_q_source+"/r2.1"
                    file_q.write(colo_br.position)
                    file_q.source=file_q_source+"/b2.1"
                    file_q.write(colo_bg.position)
                    file_q.source=file_q_source+"/g2.1"
                    file_q.write(colo_bb.position)
                    file_q.source=file_q_source+"/top.1"
                    file_q.write(top_.checked)
                    file_q.source=file_q_source+"/h1.1"
                    file_q.write(sb.position)
                    file_q.source=file_q_source+"/h2.1"
                    file_q.write(sb3.position)
                    file_q.source=file_q_source+"/fs.1"
                    file_q.write(textDateTime.font.pixelSize)
                    file_q.source=file_q_source+"/bw.1"
                    file_q.write(f_r.position)
                    file_q.source=file_q_source+"/fb.1"
                    file_q.write(f_b.checked)
                    file_q.source=file_q_source+"/ra.1"
                    file_q.write(rad_.position)/*
                    file_q.source=file_q_source+"/w.1"
                    file_q.write(winw)
                    file_q.source=file_q_source+"/h.1"
                    file_q.write(winh)*/
                    Qt.exit(0)
                }
            }
            Button{
                id:up
                width: 15
                height: 15
                x:40
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
                x:55
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
                x:70
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
                x:85
                text: ">"
                onClicked:
                {
                    window.x+=1
                }
            }
        }

        Item{
            id:cd

            Item{
                id:checks
                y:0
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
                }/*
                Item{
                    y:30
                    TextEdit {
                        id:sc
                        text: "0"
                        horizontalAlignment: Text.Center
                        font.pixelSize: 10
                    }
                }*/


                Button{
                    width: 50
                    height: 15
                    y:45
                    text: "h:m:s"
                    font.pixelSize: 10
                    onClicked:  {
                        if(text==="h:m:s")
                        {
                            text="h:m"
                            s="hh:mm"
                            textDateTime.text = Qt.formatDateTime(new Date(), s);/*
                            cwinw=100
                            winw=wid.position*cwinw*win.scale+100
                            window.width=winw*win.scale*/

                        }
                        else
                        {
                            text="h:m:s"
                            s="hh:mm:ss"
                            textDateTime.text = Qt.formatDateTime(new Date(), s);/*
                            cwinw=140
                            winw=wid.position*cwinw*win.scale+100
                            window.width=winw*win.scale*/
                        }
                        yjcd.visible=false
                    }
                }
                Button{
                    width: 50
                    height: 15
                    y:45
                    x:50
                    text: "同步时间"
                    font.pixelSize: 10
                    onClicked:  {
                        timer.running=false
                        timer_set.f=true
                        timer_set.running=true
                        yjcd.visible=false
                    }
                }
            }
            Item{
                id:appea
                y:60
                Item{

                    Text {
                        y:2
                        z:1
                        font.pixelSize: 10
                        text: "透明度"
                    }
                    Text {
                        y:13
                        z:1
                        font.pixelSize: 10
                        text: "全局"
                    }
                    ScrollBar{
                        scale: 0.5
                        y:10
                        z:0
                        id:sb
                        x:-15
                        onPositionChanged: {
                            window.opacity=position*0.95+0.05
                        }
                        position: 1
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 150
                        height: 20
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                    Text {
                        y:23
                        z:1
                        font.pixelSize: 10
                        text: "背景"
                    }
                    ScrollBar{
                        scale: 0.5
                        y:20
                        z:0
                        x:-15
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
                        height: 20
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                }
                Text{
                    y:22.5
                    text:"____________________"
                }
                Rectangle{
                    y:40
                    scale:0.5
                    Text {
                        y:0
                        z:1
                        font.pixelSize: 20
                        text: "缩放"
                    }
                    ScrollBar{
                        y:0
                        x:40
                        z:0
                        id:sb2
                        onPositionChanged: {
                            win.scale=position*8+0.1
                            window.width=winw*win.scale
                            window.height=winh*win.scale
                        }
                        position: 0.125
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 140
                        height: 20
                        stepSize: 0.001
                        snapMode: ScrollBar.SnapAlways
                    }
                    Button{
                        text: "R"
                        x:180
                        y:0
                        width: 20
                        height: 20
                        onClicked: {
                            sb2.position=0.125
                        }
                    }
                    Text{
                        y:20
                        z:1
                        font.pixelSize: 20
                        text: "宽度"
                    }
                    ScrollBar{
                        y:20
                        z:0
                        id:wid
                        x:40
                        onPositionChanged: {
                            winw=position*140*win.scale+100
                            window.width=winw*win.scale
                        }
                        position: 0.28
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 140
                        height: 20
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                    Button{
                        text: "R"
                        x:180
                        y:20
                        width: 20
                        height: 20
                        onClicked: {
                            wid.position=0.28
                        }
                    }
                    Text{
                        y:40
                        z:1
                        font.pixelSize: 20
                        text: "高度"
                    }
                    ScrollBar{
                        y:40
                        z:0
                        id:hei
                        x:40
                        onPositionChanged: {
                            winh=position*33*win.scale+30
                            window.height=winh*win.scale
                        }
                        position: 0.09
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 140
                        height: 20
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                    Button{
                        text: "R"
                        x:180
                        y:40
                        width: 20
                        height: 20
                        onClicked: {
                            hei.position=0.09
                        }
                    }
                }

                Item{
                    id:font_
                    y:71
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
                        id:f_b
                        x:60
                        checked: false
                        onCheckedChanged: {
                            textDateTime.font.bold=checked
                        }
                    }
                }
                Item{
                    id:border_
                    y:85
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
                        position: 0.1
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 110
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                }
                Rectangle{
                    y:100
                    Text{
                        text:"圆角"
                        height: 15
                        font.pixelSize: 10
                    }
                    ScrollBar{

                        scale: 0.667
                        y:0
                        z:0
                        id:rad_
                        x:5
                        onPositionChanged: {
                            winm.radius=position*winm.height/2
                            winn.radius=position*winn.height/2
                        }
                        position: 0.1
                        hoverEnabled: true
                        active:hovered || pressed
                        orientation:Qt.Horizontal
                        width: 110
                        stepSize: 0.01
                        snapMode: ScrollBar.SnapAlways
                    }
                }

                Text{
                    y:102.5
                    text:"____________________"
                }

                Item{
                    y:220
                    Button{
                        text:"清除数据"
                        font.pixelSize: 10
                        width: 50
                        height: 15
                        onClicked: {
                            file_q.source=file_q_source+"/is.1"
                            file_q.write("false")
                        }
                    }
                    Button{
                        text:"源代码"
                        font.pixelSize: 10
                        width: 50
                        x:50
                        height: 15
                        onClicked: Qt.openUrlExternally("https://github.com/lazx547/547clock")
                    }
                }


                Rectangle{
                    id:colo
                    y:120
                    Text{
                        text:"颜色"
                        font.pixelSize: 10
                    }
                    Button{
                        width: 40
                        x:20
                        height: 15
                        text: "浅色"
                        font.pixelSize: 10
                        onClicked:  {
                            colo_r.position=0
                            colo_g.position=0
                            colo_b.position=0
                            textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            colo_br.position=1
                            colo_bg.position=1
                            colo_bb.position=1
                            winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                        }
                    }
                    Button{
                        width: 40
                        x:60
                        height: 15
                        text: "深色"
                        font.pixelSize: 10
                        onClicked:  {
                            colo_r.position=1
                            colo_g.position=1
                            colo_b.position=1
                            textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            colo_br.position=0
                            colo_bg.position=0
                            colo_bb.position=0
                            winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                        }
                    }
                    Rectangle{
                        y:13
                        scale: 0.5
                        Text{
                            text:"字体&边框"
                            height: 30
                            font.pixelSize: 20
                        }
                        Text{
                            text:"R"
                            height: 30
                            y:20
                            font.pixelSize: 20
                        }
                        ScrollBar{
                            x:20
                            y:25
                            z:0
                            id:colo_r
                            onPositionChanged: {
                                textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            }
                            position: 0
                            hoverEnabled: true
                            active:hovered || pressed
                            orientation:Qt.Horizontal
                            height:20
                            width: 180
                            stepSize: 0.01
                            snapMode: ScrollBar.SnapAlways
                        }
                        Text{
                            text:"G"
                            y:40
                            height: 30
                            font.pixelSize: 20
                        }
                        ScrollBar{
                            y:45
                            z:0
                            id:colo_g
                            x:20
                            onPositionChanged: {
                                textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            }
                            position: 0
                            hoverEnabled: true
                            active:hovered || pressed
                            orientation:Qt.Horizontal
                            height:20
                            width: 180
                            stepSize: 0.004
                            snapMode: ScrollBar.SnapAlways
                        }
                        Text{
                            text:"B"
                            y:60
                            height: 30
                            font.pixelSize: 20
                        }
                        ScrollBar{
                            y:65
                            z:0
                            id:colo_b
                            x:20
                            onPositionChanged: {
                                textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                            }
                            position: 0
                            hoverEnabled: true
                            active:hovered || pressed
                            orientation:Qt.Horizontal
                            height:20
                            width: 180
                            stepSize: 0.004
                            snapMode: ScrollBar.SnapAlways
                        }
                    }
                    Rectangle{
                        y:55
                        scale: 0.5
                        Text{
                            text:"背景"
                            height: 30
                            font.pixelSize: 20
                        }
                        Text{
                            text:"R"
                            height: 30
                            y:20
                            font.pixelSize: 20
                        }
                        ScrollBar{
                            x:20
                            y:25
                            z:0
                            id:colo_br
                            onPositionChanged: {
                                winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                            }
                            position: 1
                            hoverEnabled: true
                            active:hovered || pressed
                            orientation:Qt.Horizontal
                            height:20
                            width: 180
                            stepSize: 0.01
                            snapMode: ScrollBar.SnapAlways
                        }
                        Text{
                            text:"G"
                            y:40
                            height: 30
                            font.pixelSize: 20
                        }
                        ScrollBar{
                            y:45
                            z:0
                            id:colo_bg
                            x:20
                            onPositionChanged: {
                                winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                            }
                            position: 1
                            hoverEnabled: true
                            active:hovered || pressed
                            orientation:Qt.Horizontal
                            height:20
                            width: 180
                            stepSize: 0.004
                            snapMode: ScrollBar.SnapAlways
                        }
                        Text{
                            text:"B"
                            y:60
                            height: 30
                            font.pixelSize: 20
                        }
                        ScrollBar{
                            y:65
                            z:0
                            id:colo_bb
                            x:20
                            onPositionChanged: {
                                winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                            }
                            position: 1
                            hoverEnabled: true
                            active:hovered || pressed
                            orientation:Qt.Horizontal
                            height:20
                            width: 180
                            stepSize: 0.004
                            snapMode: ScrollBar.SnapAlways
                        }
                    }

                }
            }
        }
    }
}
