import QtQuick
import QtQuick.Controls
import QtQuick.Window
import GFile 1.2
import DelegateUI.Controls 1.0
import QtQuick.Dialogs

Window {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint//无边框 最上层
    width: 140
    height: 33
    color: "#00000000"//背景透明（r,g,b,a）
    property string s:"hh:mm:ss"//显示模式
    property int winw:140//默认宽度
    property int winh:33//默认高度
    //property int cwinw:140

    MouseArea{
        z:115678
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton |Qt.MiddleButton
        onClicked: (mouse)=>{
                       if(mouse.button===Qt.MiddleButton && can_pau.checked  &&!can_s.checked)//如果按下中键 同时 允许暂停 未锁定 则暂停
                       {
                           timer.running=!timer.running
                           textDateTime.text = Qt.formatDateTime(new Date(), s);
                       }
                       else if(mouse.button===Qt.RightButton)//如果按下右键 显示右键菜单
                       {
                           yjcd.x=mouseX+window.x
                           yjcd.y=mouseY+window.y
                           if(mouseY+window.y>=yjcd.height) yjcd.y-=yjcd.height//如果窗口上方的高度不足以显示右键菜单，就显示在窗口下方
                           yjcd.visible=true
                       }


                   }
        onWheel: (wheel)=>{//滚动鼠标滚轮时缩放窗口
                     if(!can_s.checked)//如果未锁定
                     {
                         if(wheel.angleDelta.y>0)
                         {
                             win.scale+=0.1
                             window.width=winw*win.scale
                             window.height=winh*win.scale
                         }
                         else
                         {
                             if(window.width>=30){//如果窗口宽度大于30，防止缩放过小时窗口直接消失
                                 win.scale-=0.1
                                 window.width=winw*win.scale
                                 window.height=winh*win.scale
                             }
                         }
                         sb2.position=(win.scale-0.1)/8//同时修改“缩放”滚动条位置
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
            Text{//显示时间
                id: textDateTime
                text: Qt.formatDateTime(new Date(), s);
                font.pixelSize: 35
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: 0
            }
            Timer{//定时器 刷新时间
                id: timer
                interval: 100 //间隔(单位毫秒=10^-3秒）
                running: false
                repeat: true //重复
                onTriggered:{
                    // if(top_.checked)
                    // {
                    //     window.flags=Qt.FramelessWindowHint
                    //     window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    // }
                    textDateTime.text = Qt.formatDateTime(new Date(), s);
                }
            }
            Timer{//定时器 初始化程序/同步时间-即在整秒时启动计时器
                id:timer_set
                interval: 1
                property bool f:true//是否是第一次循环
                property bool f2:true//是否读取保存的状态
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
                            timer.running=true//在整秒时启动刷新时间的计时器，使时间更准确
                            running=false
                            if(f2){//
                                f2=false
                                file_q.read_()
                            }
                        }
                    }
                }
            }
        }
        onScaleChanged: {//当缩放修改时同步修改边框大小、背景&边框圆角大小
            winn.radius=rad_.position*win.height/2
            winm.radius=rad_.position*win.height/2
            winn.border.width=f_r.position*win.scale*18
        }
        anchors.fill: parent
        DragHandler {//按下拖动以移动窗口
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active &&!can_s.checked)
                {
                    window.startSystemMove()
                }
            }
        }
    }
    GFile{//文件操作
        id:file_q
        function save()//正常保存
        {
            file_q.save2("./value.1")
        }
        function save2(b){
            var a=colo_r.position.toString()+","//文字&边框颜色-r值
            a+=colo_g.position.toString()+","   //           -g值
            a+=colo_b.position.toString()+","   //           -b值
            a+=colo_br.position.toString()+","  //背景颜色-r值
            a+=colo_bb.position.toString()+","  //       -g值
            a+=colo_bg.position.toString()+","  //       -b值
            a+=op_a.position.toString()+","     //透明度-全局
            a+=op_b.position.toString()+","     //透明度-背景
            a+=f_r.position.toString()+","      //字体大小
            a+=rad_.position.toString()+","     //圆角大小
            a+=wid.position.toString()+","      //宽度
            a+=hei.position.toString()+","      //高度
            a+=top_.checked.toString()+","      //是否显示在最上层
            a+=can_pau.checked.toString()+","   //是否允许暂停
            a+=show_type.checked.toString()+"," //显是否显示秒
            a+=f_b.checked.toString()+","       //字体是否加粗
            file_q.source=b
            file_q.write(a)
        }

        function read_(){//判断是否是第一次启动
            var a=0
            file_q.create("./")
            file_q.source="./is.1"
            if(file_q.is(file_q.source))
            {
                if(file_q.read()==="true")//不是第一次启动
                    file_q.read2("./value.1")//读取保存的状态
            }
            if(a==0)//是第一次启动
            {
                file_q.source="./is.1"
                file_q.write("true")
                file_q.save()//保存当前状态
            }
        }
        function read2(a){//读取保存的状态
            file_q.source=a
            var s=file_q.read()
            colo_r.position=s.slice(0,s.indexOf(","))   //文字&边框颜色-r值
            s=s.slice(s.indexOf(",")+1,s.length)
            colo_g.position=s.slice(0,s.indexOf(","))   //           -g值
            s=s.slice(s.indexOf(",")+1,s.length)
            colo_b.position=s.slice(0,s.indexOf(","))   //           -b值
            s=s.slice(s.indexOf(",")+1,s.length)
            colo_br.position=s.slice(0,s.indexOf(","))  //背景颜色-r值
            s=s.slice(s.indexOf(",")+1,s.length)
            colo_bb.position=s.slice(0,s.indexOf(","))  //       -g值
            s=s.slice(s.indexOf(",")+1,s.length)
            colo_bg.position=s.slice(0,s.indexOf(","))  //       -b值
            s=s.slice(s.indexOf(",")+1,s.length)
            op_a.position=s.slice(0,s.indexOf(","))     //透明度-全局
            s=s.slice(s.indexOf(",")+1,s.length)
            op_b.position=s.slice(0,s.indexOf(","))     //透明度-背景
            s=s.slice(s.indexOf(",")+1,s.length)
            f_r.position=s.slice(0,s.indexOf(","))      //字体大小
            s=s.slice(s.indexOf(",")+1,s.length)
            rad_.position=s.slice(0,s.indexOf(","))     //圆角大小
            s=s.slice(s.indexOf(",")+1,s.length)
            wid.position=s.slice(0,s.indexOf(","))      //宽度
            s=s.slice(s.indexOf(",")+1,s.length)
            hei.position=s.slice(0,s.indexOf(","))      //高度
            s=s.slice(s.indexOf(",")+1,s.length)
            top_.checked=s.slice(0,s.indexOf(","))=="true"?true:false       //是否显示在最上层
            s=s.slice(s.indexOf(",")+1,s.length)
            can_pau.checked=s.slice(0,s.indexOf(","))=="true"?true:false    //是否允许暂停
            s=s.slice(s.indexOf(",")+1,s.length)
            show_type.checked=s.slice(0,s.indexOf(","))=="true"?true:false  //显是否显示秒
            s=s.slice(s.indexOf(",")+1,s.length)
            f_b.checked=s.slice(0,s.indexOf(","))=="true"?true:false        //字体是否加粗
            a=1
        }
    }
    Window{//右键菜单
        id:yjcd
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint//无边框 最上层
        width: 180
        height: 424
        color: "#00000000"
        onActiveFocusItemChanged: {//失去焦点时隐藏
            if(!activeFocusItem)
                visible=false
        }
        Rectangle{//背景 实现圆角
            anchors.fill: parent
            radius: 5
        }

        Rectangle
        {
            transformOrigin: Item.TopLeft
            scale: 0.75
            width: yjcd.width*2*scale
            height: yjcd.height*2*scale
            color: "#00000000"
            radius: 3
            id:cd_
            Item{
                id:move
                y:534
                DelButton{//关闭按钮
                    text: qsTr("关闭")
                    width: 50
                    height: 30
                    onClicked: {
                        file_q.save()
                        Qt.exit(0)
                    }
                }
                DelButton{//保存按钮
                    text:"保存"
                    font.pixelSize: 16
                    width: 50
                    x:50
                    height: 30
                    onClicked: file_q.save()
                }
                Movetool{//窗口移动工具
                    x:100
                    window:window
                }
            }

            Item{
                id:cd

                Item{
                    CscrollBar{//滚动条 右键菜单缩放 bug
                        id:f12_1
                        visible: false
                        y:0
                        z:56789
                        minValue: 50
                        maxValue: 150
                        text:"scale"
                        position: 0
                        stepSize: 0.01
                        onPositionChanged: {
                            yjcd.width=(position+1)*120
                            yjcd.height=(position+1)*310
                            cd_.scale=position+0.5
                        }
                    }

                    id:checks
                    y:0
                    width: 120
                    Ccheckbox{//是否显示在最上层
                        id:top_
                        width: 200
                        height: 20
                        text: "显示在最上层"
                        checked: true
                        onCheckedChanged: {
                            if(!checked) window.flags=Qt.FramelessWindowHint
                            else window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                            yjcd.visible=false
                        }
                    }
                    Ccheckbox{//是否允许暂停
                        id:can_pau
                        width: 200
                        height: 20
                        y:top_.y+20
                        text: "允许暂停"
                        checked: true
                        onCheckedChanged: {
                            yjcd.visible=false
                        }
                    }
                    Ccheckbox{//锁定
                        id:can_s
                        width: 200
                        height: 20
                        x:160
                        y:top_.y
                        text: "锁定"
                        checked: false
                        onCheckedChanged: {
                            yjcd.visible=false
                        }
                    }
                    Ccheckbox{//是否显示秒
                        id:show_type
                        width: 200
                        height: 20
                        x:145
                        y:can_pau.y
                        text: "显示秒"
                        checked: true
                        onCheckedChanged: {
                            if(!checked) s="hh:mm"
                            else s="hh:mm:ss"
                            textDateTime.text=Qt.formatDateTime(new Date(), s);
                            yjcd.visible=false
                        }
                    }
                }
                Item{
                    id:appea
                    y:show_type.y+20
                    Item{//调整透明度
                        id:opac
                        Text {
                            y:2
                            z:1
                            font.pixelSize: 20
                            text: "透明度"
                        }
                        CscrollBar{//全局透明度
                            y:25
                            id:op_a
                            text:"全局"
                            onPositionChanged: {
                                window.opacity=position*0.95+0.05
                            }
                            position: 1
                        }
                        CscrollBar{//背景透明度
                            y:45
                            id:op_b
                            text:"背景"
                            onPositionChanged: {
                                winm.opacity=position
                            }
                            position: 1
                        }
                    }
                    Item{//调整大小
                        id:scale_
                        y:opac.y+60
                        Text{
                            y:2
                            text:"大小"
                            font.pixelSize: 20
                        }

                        CscrollBar{//调整缩放
                            y:25
                            text:"缩放"
                            id:sb2
                            reset:true
                            defaul: 0.1
                            minValue: 10
                            maxValue: 810
                            onPositionChanged: {
                                win.scale=position*8+0.1
                                window.width=winw*win.scale
                                window.height=winh*win.scale
                            }
                            position: 0.125
                            stepSize: 0.001
                        }
                        CscrollBar{//调整宽度
                            y:45
                            text:"宽度"
                            id:wid
                            reset:true
                            defaul: 0.28
                            minValue: 100
                            maxValue: 240
                            onPositionChanged: {
                                winw=position*140*win.scale+100
                                window.width=winw*win.scale
                            }
                            position: 0.28
                            //Component.onCompleted: position=140/(win.width*win.scale-100)
                        }
                        CscrollBar{//调整高度
                            y:65
                            text:"高度"
                            id:hei
                            reset:true
                            defaul: 0.1
                            minValue: 30
                            maxValue: 63
                            onPositionChanged: {
                                winh=position*33*win.scale+30
                                window.height=winh*win.scale
                            }
                            position: 0.09
                            //Component.onCompleted: position=140/(win.width*win.scale-100)
                        }
                    }

                    Item{//调整字体
                        id:font_
                        y:scale_.y+80
                        Text{
                            y:2
                            text:"字体"
                            font.pixelSize: 20
                        }
                        CscrollBar{//调整字号
                            id:font_size
                            y:26
                            reset:true
                            defaul: 0.31
                            text: "字号"
                            position: 0.31
                            stepSize: 0.01
                            onPositionChanged: {
                                textDateTime.font.pixelSize=position*100
                            }
                        }
                        Ccheckbox{//字体是否加粗
                            text: "加粗"
                            width: 50
                            height: 20
                            id:f_b
                            x:100
                            y:6
                            checked: false
                            onCheckedChanged: {
                                textDateTime.font.bold=checked
                            }
                        }
                        Item {//调整文字位置
                            y:6
                            x:120
                            DelButton{//上移
                                id:up
                                width: 20
                                height: 20
                                x:40
                                rotation: 90
                                text: "<"
                                onClicked:
                                {
                                    textDateTime.anchors.verticalCenterOffset-=1
                                }
                            }
                            DelButton{//下移
                                id:down
                                width: 20
                                height: 20
                                rotation: 90
                                x:60
                                text: ">"
                                onClicked:
                                {
                                   textDateTime.anchors.verticalCenterOffset+=1
                                }
                            }
                            DelButton{//左移
                                id:left
                                width: 20
                                height:20
                                x:80
                                text: "<"
                                onClicked:
                                {
                                    textDateTime.anchors.horizontalCenterOffset-=1
                                }
                            }
                            DelButton{//右移
                                id:right
                                width: 20
                                height: 20
                                x:100
                                text: ">"
                                onClicked:
                                {
                                    textDateTime.anchors.horizontalCenterOffset+=1
                                }
                            }
                        }
                    }
                    Item{//调整边框
                        y:font_.y+45
                        id:bord
                        Text{
                            y:2
                            text:"边框"
                            font.pixelSize: 20
                        }
                        CscrollBar{//调整边框大小
                            id:f_r
                            y:25
                            text:"大小"
                            onPositionChanged: {
                                winn.border.width=position*win.scale*18
                            }
                            position: 0.1
                            Component.onCompleted: position=1.8/20
                        }
                        CscrollBar{//调整圆角大小
                            y:f_r.y+20
                            id:rad_
                            text:"圆角"
                            onPositionChanged: {
                                winm.radius=position*winm.height/2
                                winn.radius=position*winn.height/2
                            }
                            position: 0.1
                        }
                    }
                    Rectangle{//调整颜色
                        id:colo
                        y:bord.y+68
                        Text{
                            text:"颜色"
                            font.pixelSize: 20
                        }
                        Item{//预设
                            id:colors
                            x:40
                            y:3
                            z:45678
                            DelButton{
                                width: 60
                                x:20
                                height: 25
                                text: "粉色"
                                font.pixelSize: 18
                                onClicked:  {
                                    colo_r.position=1//文字&边框颜色
                                    colo_g.position=0.56
                                    colo_b.position=0.74
                                    textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    colo_br.position=0.64//背景颜色
                                    colo_bg.position=0.64
                                    colo_bb.position=0.64
                                    winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                                    f_r.position=0//字体大小
                                    rad_.position=0.72//圆角大小
                                    op_b.position=0.31//背景透明度
                                }
                            }
                            DelButton{
                                width: 60
                                x:80
                                height: 25
                                text: "浅色"
                                font.pixelSize: 18
                                onClicked:  {
                                    colo_r.position=0//文字&边框颜色
                                    colo_g.position=0
                                    colo_b.position=0
                                    textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    colo_br.position=1//背景颜色
                                    colo_bg.position=1
                                    colo_bb.position=1
                                    winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                                }
                            }
                            DelButton{
                                width: 60
                                x:140
                                height: 25
                                text: "深色"
                                font.pixelSize:18
                                onClicked:  {
                                    colo_r.position=1//文字&边框颜色
                                    colo_g.position=1
                                    colo_b.position=1
                                    textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    colo_br.position=0//背景颜色
                                    colo_bg.position=0
                                    colo_bb.position=0
                                    winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                                }
                            }
                        }
                        Rectangle{
                            color:"#00000000"
                            y:25
                            Text{
                                text:"字体&边框"
                                height: 60
                                font.pixelSize: 18
                            }
                            CscrollBar{
                                y:25
                                id:colo_r
                                text:"R"
                                onPositionChanged: {
                                    textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                }
                                position: 0
                            }
                            CscrollBar{
                                y:45
                                id:colo_g
                                text:"G"
                                onPositionChanged: {
                                    textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                }
                                position: 0
                            }
                            CscrollBar{
                                y:65
                                id:colo_b
                                text:"B"
                                onPositionChanged: {
                                    textDateTime.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                    winn.border.color=Qt.rgba(colo_r.position,colo_g.position,colo_b.position)
                                }
                                position: 0
                            }
                        }
                        Rectangle{
                            y:110
                            Text{
                                text:"背景"
                                height: 60
                                font.pixelSize: 18
                            }
                            CscrollBar{
                                y:26
                                id:colo_br
                                text:"R"
                                onPositionChanged: {
                                    winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                                }
                                position: 0
                            }
                            CscrollBar{
                                y:46
                                id:colo_bg
                                text:"G"
                                onPositionChanged: {
                                    winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                                }
                                position: 0
                            }
                            CscrollBar{
                                y:66
                                id:colo_bb
                                text:"B"
                                onPositionChanged: {
                                    winm.color=Qt.rgba(colo_br.position,colo_bg.position,colo_bb.position)
                                }
                                position: 0
                            }
                        }

                    }
                }
                Item{
                    y:colo.y+appea.y+200
                    DelButton{
                        text:"清除数据"
                        font.pixelSize: 16
                        width:80
                        height: 20
                        onClicked: {
                            if(text=="清除数据")
                            {
                                file_q.source=file_q_source+"/is.1"
                                file_q.write("false")
                                text="取消清除"
                            }
                            else
                            {
                                file_q.source=file_q_source+"/is.1"
                                file_q.write("true")
                                text="清除数据"
                            }
                        }
                    }
                    DelButton{
                        id:time_set
                        width: 80
                        height: 20
                        x:80
                        text: "同步时间"
                        font.pixelSize:16
                        onClicked:  {
                            timer.running=false
                            timer_set.f=true
                            timer_set.running=true
                            yjcd.visible=false
                        }
                    }
                    DelButton{
                        id:date_reread
                        width: 80
                        height: 20
                        x:160
                        text: "重载设置"
                        font.pixelSize:16
                        onClicked: file_q.read2("./value.1")
                    }
                    DelButton{
                        text:".12"
                        font.pixelSize: 2
                        width: 40
                        x:200
                        y:20
                        height: 20
                        onClicked: f12_1.visible=!f12_1.visible
                    }
                    DelButton{
                        id:date_reset
                        width: 140
                        height: 20
                        x:0
                        y:20
                        text: "不保存并退出"
                        font.pixelSize:16
                        onClicked: Qt.exit(0)
                    }
                    DelButton{
                        text:"关于"
                        font.pixelSize: 16
                        width: 60
                        x:140
                        y:20
                        height: 20
                        onClicked: about.visible=true
                        Window{
                            id:about
                            width: 300
                            height: 150
                            minimumHeight: height
                            maximumHeight: height
                            minimumWidth: width
                            maximumWidth: width
                            Image {
                                x:20
                                y:10
                                width: 70
                                height: 70
                                source: "qrc:/Qt.png"
                            }
                            Text{
                                x:90
                                y:25
                                font.pixelSize: 20
                                text:"Made with Qt6"
                            }
                            Text {
                                x:90
                                y:45
                                text: "(Desktop Qt 6.7.3 MinGW 64-bit)"
                            }
                            DelButton{
                                text:"源代码"
                                font.pixelSize: 16
                                width: 80
                                x:30
                                y:80
                                height: 20
                                onClicked: Qt.openUrlExternally("https://github.com/lazx547/547clock")
                            }
                            DelButton{
                                text:"547官网"
                                font.pixelSize: 16
                                width: 100
                                x:170
                                y:80
                                height: 20
                                onClicked: Qt.openUrlExternally("https://lazx547.github.io")
                            }
                            Text{
                                x:20
                                y:110
                                text:"使用的开源组件:DelButton"
                            }
                            DelButton{
                                text:"访问仓库"
                                font.pixelSize: 16
                                width: 100
                                x:170
                                y:105
                                height: 20
                                onClicked: Qt.openUrlExternally("https://github.com/mengps/QmlControls/tree/master/DelButton")
                            }
                        }
                    }
                    // DelButton{
                    //     text:"读取设置"
                    //     font.pixelSize: 16
                    //     width: 80
                    //     x:0
                    //     y:20
                    //     height: 20
                    //     onClicked: {
                    //         fileDialog.open()
                    //         file_q.read2()
                    //     }
                    // }
                    // DelButton{
                    //     text:"导出设置"
                    //     font.pixelSize: 16
                    //     width: 80
                    //     x:80
                    //     y:20
                    //     height: 20
                    //     onClicked: fileDialog.open()
                    // }
                    // FileDialog {
                    // id: fileDialog
                    // title: "选择文件"
                    // fileMode: FileDialog.OpenFile
                    // }
                    // FileDialog {
                    // id: fileDialog2
                    // title: "保存文件"
                    // fileMode: FileDialog.SaveFile
                    // onSelectedFileChanged: {
                    //     console.log(fileDialog2.selectedFile)
                    //     file_q.save2(fileDialog2.selectedFile)
                    // }
                    // }
                }
            }
        }
    }
}
