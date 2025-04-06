import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt.labs.platform
import Qt5Compat.GraphicalEffects
import GFile 1.2

Window{
    id: window
    visible: true
    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    width:win.width*win.scale
    height:win.height*win.scale
    color: "transparent"
    opacity: window_opa.value*0.99+0.01

    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height

    Timer{
        id:timer_set
        interval: 1
        property bool f:true//是否是第一次循环
        property bool f2:true//是否读取保存的状态
        running: true
        repeat: true
        onTriggered:{
            if(f)
            {
                time_text.text= Qt.formatDateTime(new Date(), time_text.type);
                f=false
            }
            else
            {
                if(time_text.text==Qt.formatDateTime(new Date(), time_text.type))
                {
                    refresh.running=true//在整秒时启动刷新时间的计时器，使时间更准确
                    running=false
                    if(f2){//
                        f2=false
                        file.read_()
                    }
                    window.x=(sys_width-window.width)/2
                    window.y=(sys_height-window.height)/2
                }
            }
        }
    }

    Rectangle{
        id:win
        transformOrigin: Item.TopLeft
        width:window_width.value*240+40
        height:window_height.value*100+10
        border.width: border_width.value*win.height/2
        border.color:Qt.rgba(color_border.r,color_border.g,color_border.b,color_border.a)
        color:Qt.rgba(color_back.r,color_back.g,color_back.b,color_back.a)
        scale:window_scale.value*80.9+0.01
        radius:border_radiu.value*win.height/2
        Text{
            id:time_text
            anchors.centerIn:  parent
            property string type:"hh:mm:ss"
            font.pixelSize:text_size.value*100+5
            color:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            Timer{
                id:refresh
                interval: 10
                onTriggered: time_text.text=Qt.formatDateTime(new Date(), time_text.type);
                running: false
                repeat: true
            }
        }
        MouseArea{
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
            onClicked: (event)=>{
                           if(event.button===Qt.LeftButton) menu.visible=false
                           else if(event.button===Qt.RightButton)
                           {
                               menu.x=window.x+mouseX*win.scale
                               menu.y=window.y+mouseY*win.scale
                               if(menu.x+menu.width>sys_width) menu.x-=menu.width
                               if(menu.y+menu.height>sys_height) menu.y-=menu.height
                               menu.visible=true
                           }
                           else if(event.button===Qt.MiddleButton && time_pauce.checked)
                               refresh.running=!refresh.running
                       }
            onWheel:(wheel)=>{
                        if(true)
                        {
                            if(wheel.angleDelta.y>0) win.scale+=0.1
                            else if(wheel.angleDelta.y<0)
                            {
                                if(win.scale>0.2)  win.scale-=0.1
                            }
                            window_scale.setValue((win.scale-0.01)/80.9)
                        }
                    }
        }
    }
    GFile{//文件操作
        id:file
        function save()//正常保存
        {
            file.save2("./value.txt")
        }
        function save2(b){
            var a=color_text.r.toString()+","+color_text.g.toString()+","+color_text.b.toString()+","+color_text.a.toString()+","   //背景颜色
            a+=color_border.r.toString()+","+color_border.g.toString()+","+color_border.b.toString()+","+color_border.a.toString()+","      //文字颜色
            a+=color_back.r.toString()+","+color_back.g.toString()+","+color_back.b.toString()+","+color_back.a.toString()+","      //边框颜色
            a+=window_opa.value.toString()+","                                                                       //透明度
            a+=window_width.value.toString()+","                                                                             //宽度
            a+=window_height.value.toString()+","                                                                             //高度
            a+=border_width.value.toString()+","                                                                             //边框宽度
            a+=border_radiu.value.toString()+","                                                                            //圆角大小
            a+=text_size.value.toString()+","                                                                       //字体大小
            a+=time_text.anchors.horizontalCenterOffset+","                                                      //文字水平偏移
            a+=time_text.anchors.verticalCenterOffset+","                                                        //文字竖直偏移
            a+=text_bord.checked+","                                                                                      //是否加粗
            a+=window_top.checked+","                                                                                     //是否置顶
            a+=time_pauce.checked+","                                                                                  //是否允许暂停
            a+=window_lock.checked+","                                                                                    //是否锁定
            a+=show_type.checked+","                                                                                //是否显示秒
            file.source=b
            file.write(a)
        }

        function read_(){//判断是否是第一次启动
            var a=0
            file.create("./")
            file.source="./is.txt"
            if(file.is(file.source))
            {
                if(file.read()==="true")//不是第一次启动
                    file.read2("./value.txt")//读取保存的状态
            }
            if(a==0)//是第一次启动
            {
                file.source="./is.txt"
                file.write("true")
                file.save()//保存当前状态
            }
        }
        function read2(a){//读取保存的状态
            file.source=a
            var s=file.read(),r_,g_,b_,a_
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            color_text.setColor(r_,g_,b_,a_)                                    //文字颜色
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            color_border.setColor(r_,g_,b_,a_)                                    //边框颜色
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            color_back.setColor(r_,g_,b_,a_)                                    //背景颜色
            window_opa.setValue(Number(s.slice(0,s.indexOf(","))))           //透明度
            s=s.slice(s.indexOf(",")+1,s.length)
            window_width.setValue(s.slice(0,s.indexOf(",")))                         //宽度
            s=s.slice(s.indexOf(",")+1,s.length)
            window_height.setValue(s.slice(0,s.indexOf(",")))                         //高度
            s=s.slice(s.indexOf(",")+1,s.length)
            border_width.setValue(s.slice(0,s.indexOf(",")))                         //边框宽度
            s=s.slice(s.indexOf(",")+1,s.length)
            border_radiu.setValue(s.slice(0,s.indexOf(",")))                        //圆角大小
            s=s.slice(s.indexOf(",")+1,s.length)
            text_size.setValue(s.slice(0,s.indexOf(",")))                   //字体大小
            s=s.slice(s.indexOf(",")+1,s.length)                            //文字水平偏移
            time_text.anchors.horizontalCenterOffset=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)                            //文字竖直偏移
            time_text.anchors.verticalCenterOffset=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            text_bord.checked=s.slice(0,s.indexOf(","))=="true" ? true:false      //是否加粗
            s=s.slice(s.indexOf(",")+1,s.length)
            window_top.checked=s.slice(0,s.indexOf(","))=="true" ? true:false     //是否置顶
            s=s.slice(s.indexOf(",")+1,s.length)
            time_pauce.checked=s.slice(0,s.indexOf(","))=="true" ? true:false  //是否允许暂停
            s=s.slice(s.indexOf(",")+1,s.length)
            window_lock.checked=s.slice(0,s.indexOf(","))=="true" ? true:false    //是否锁定
            s=s.slice(s.indexOf(",")+1,s.length)
            show_type.checked=s.slice(0,s.indexOf(","))=="true" ? true:false//是否显示秒
            a=1
        }
    }
    Window{
        id:menu
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 204
        height:334
        color:"transparent"
        Rectangle{
            id:menu_back
            width: menu.width
            height:menu.height
            border.width: 2
            border.color: "#80808080"
            transformOrigin: Item.TopLeft

        }
        Item{
            id:menuItems
            x:menu_back.border.width
            y:menu_back.border.width
            width: menu.width-menu_back.border.width
            height:menu.height-menu_back.border.width
            Item{
                id:window_set
                CscrollBar{
                    id:window_opa
                    text: "透明"
                    maxValue: 100
                    minValue: 1
                }
                CscrollBar{
                    id:window_scale
                    y:20
                    text:"缩放"
                    maxValue: 6100
                    minValue: 10
                    step:0.00016
                    Component.onCompleted: setValue(0.0164)
                    onValueChanged: win.scale=value*80.9+0.01
                }
                CscrollBar{
                    id:window_width
                    y:40
                    text:"宽度"
                    maxValue: 280
                    minValue: 40
                    step:0.00416;
                    reset:0.5
                    Component.onCompleted: setValue(reset)
                }
                CscrollBar{
                    id:window_height
                    y:60
                    text:"宽度"
                    maxValue: 110
                    minValue: 10
                    reset:0.3
                    Component.onCompleted: setValue(reset)
                }
            }
            Item{
                id:text_set
                y:85
                Text{
                    text:"文字"
                    font.pixelSize:18
                }
                Item{
                    y:3
                    x:menuItems.width-122
                    ImaButton{
                        id:text_bord
                        radiusBg: 0
                        width: 20
                        height: 20
                        img:"./images/bord_.png"
                        checked: false
                        onClicked: checked=!checked
                        onCheckedChanged: {
                            time_text.font.bold=checked
                            img=checked? "./images/bord.png":"./images/bord_.png"
                        }
                        toolTipText: "文字加粗"
                    }
                    Cbutton{//上移
                        id:up
                        width: 20
                        height: 20
                        x:20
                        rotation: 90
                        text: "<"
                        onClicked:
                        {
                            time_text.anchors.verticalCenterOffset-=1
                        }

                        toolTipText: "文字上移一个单位"
                        radiusBg: 0
                    }
                    Cbutton{//下移
                        id:down
                        width: 20
                        height: 20
                        x:40
                        rotation: 90
                        text: ">"
                        onClicked:
                        {
                            time_text.anchors.verticalCenterOffset+=1
                        }
                        toolTipText: "文字下移一个单位"
                        radiusBg: 0
                    }
                    Cbutton{//左移
                        id:left
                        width: 20
                        height:20
                        x:60
                        text: "<"
                        onClicked:
                        {
                            time_text.anchors.horizontalCenterOffset-=1
                        }
                        toolTipText: "文字左移一个单位"
                        radiusBg: 0
                    }
                    Cbutton{//右移
                        id:right
                        width: 20
                        height: 20
                        x:80
                        text: ">"
                        onClicked:
                        {
                            time_text.anchors.horizontalCenterOffset+=1
                        }
                        toolTipText: "文字右移一个单位"
                        radiusBg: 0
                    }
                    ImaButton{
                        width: 20
                        height: 20
                        x:100
                        img:"./images/reset.png"
                        onClicked: {
                            time_text.anchors.horizontalCenterOffset=0
                            time_text.anchors.verticalCenterOffset=0
                        }
                        toolTipText: "重置文字位置"
                        radiusBg: 0
                    }

                }
                CscrollBar{
                    y:25
                    id:text_size
                    minValue: 5
                    maxValue: 105
                    reset:0.32
                    Component.onCompleted: setValue(reset)
                    text:"大小"
                }
            }
            Item{
                id:border_set
                y:130
                Text{
                    text:"边框"
                    font.pixelSize:18
                }
                CscrollBar{
                    y:25
                    id:border_width
                    minValue:0
                    maxValue:win.height/2
                    step:1/(win.width/2)
                    reset:0.1
                    Component.onCompleted: setValue(reset)
                    text:"大小"
                }
                CscrollBar{
                    y:45
                    id:border_radiu
                    minValue:0
                    maxValue:win.height/2
                    step:1/(win.width/2)
                    reset:0
                    Component.onCompleted: setValue(reset)
                    text:"圆角"
                }
            }
            Item{
                id:color_set
                y:195
                Text{
                    text:"颜色"
                    font.pixelSize:18
                }
                Item{
                    y:20
                    Text{
                        text:"文字:"
                        height: 60
                        font.pixelSize: 16
                    }
                    Cbutton{
                        x:menuItems.width-132
                        width: 55
                        height: 20
                        text:"同边框"
                        font.pixelSize: 14
                        onClicked: {
                            color_text.setColor(color_border.r,color_border.g,color_border.b,color_border.a)
                        }
                        toolTipText: "从边框复制颜色"
                        radiusBg: 0
                    }
                    Cbutton{
                        x:menuItems.width-77
                        width: 55
                        height: 20
                        text:"同背景"
                        font.pixelSize: 14
                        onClicked: {
                            color_text.setColor(color_back.r,color_back.g,color_back.b,color_back.a)
                        }
                        toolTipText: "从背景复制颜色"
                        radiusBg: 0
                    }
                    Cbutton{
                        id:color_text_button
                        x:menuItems.width-22
                        width: 20
                        height: 20
                        text:">"
                        onClicked: {
                            if(text===">")
                            {
                                color_text.x=menu.x+menu.width
                                color_text.y=menu.y+color_set.y+20
                                if(color_text.x+color_text.width>sys_width) color_text.x-=menu.width+color_text.width
                                //hidewindows()
                                color_text.visible=true
                            }
                        }
                        toolTipText: "展开颜色选择窗口"
                        radiusBg: 0
                    }
                    ColorPicker{
                        id:color_text
                        x:240
                        onActiveFocusItemChanged: {//失去焦点时隐藏
                            if(!activeFocusItem && !menu.active)
                                visible=false
                        }
                        Component.onCompleted: setColor(0,0,0,1)
                        onVisibleChanged: {
                            if(visible)color_text_button.text="<"
                            else color_text_button.text=">"
                        }
                    }
                }
                Item{
                    y:40
                    Text{
                        text:"边框:"
                        height: 60
                        font.pixelSize: 16
                    }
                    Cbutton{
                        x:menuItems.width-132
                        width: 55
                        height: 20
                        text:"同文字"
                        font.pixelSize: 14
                        onClicked: {
                            color_border.setColor(color_text.r,color_text.g,color_text.b,color_text.a)
                        }
                        toolTipText: "从文字复制颜色"
                        radiusBg: 0
                    }
                    Cbutton{
                        x:menuItems.width-77
                        width: 55
                        height: 20
                        text:"同背景"
                        font.pixelSize: 14
                        onClicked: {
                            color_text.setColor(color_back.r,color_back.g,color_back.b,color_back.a)
                        }
                        toolTipText: "从背景复制颜色"
                        radiusBg: 0
                    }
                    Cbutton{
                        id:color_border_button
                        x:menuItems.width-22
                        width: 20
                        height: 20
                        text:">"
                        onClicked: {
                            if(text===">")
                            {
                                color_border.x=menu.x+menu.width
                                color_border.y=menu.y+color_set.y+40
                                if(color_border.x+color_border.width>sys_width) color_border.x-=menu.width+color_border.width
                                //hidewindows()
                                color_border.visible=true
                            }
                        }
                        toolTipText: "展开颜色选择窗口"
                        radiusBg: 0
                    }
                    ColorPicker{
                        id:color_border
                        x:240
                        onActiveFocusItemChanged: {//失去焦点时隐藏
                            if(!activeFocusItem && !menu.active)
                                visible=false
                        }
                        Component.onCompleted: setColor(0.133,0.133,0.133,0.75)
                        onVisibleChanged: {
                            if(visible)color_border_button.text="<"
                            else color_border_button.text=">"
                        }
                    }
                }
                Item{
                    y:60
                    Text{
                        text:"背景:"
                        height: 60
                        font.pixelSize: 16
                    }
                    Cbutton{
                        x:menuItems.width-132
                        width: 55
                        height: 20
                        text:"同文字"
                        font.pixelSize: 14
                        onClicked: {
                            color_back.setColor(color_text.r,color_text.g,color_text.b,color_text.a)
                        }
                        toolTipText: "从文字复制颜色"
                        radiusBg: 0
                    }
                    Cbutton{
                        x:menuItems.width-77
                        width: 55
                        height: 20
                        text:"同边框"
                        font.pixelSize: 14
                        onClicked: {
                            color_back.setColor(color_border.r,color_border.g,color_border.b,color_border.a)
                        }
                        toolTipText: "从边框复制颜色"
                        radiusBg: 0
                    }
                    Cbutton{
                        id:color_back_button
                        x:menuItems.width-22
                        width: 20
                        height: 20
                        text:">"
                        onClicked: {
                            if(text===">")
                            {
                                color_back.x=menu.x+menu.width
                                color_back.y=menu.y+color_set.y+60
                                if(color_border.x+color_border.width>sys_width) color_back.x-=menu.width+color_back.width
                                //hidewindows()
                                color_back.visible=true
                            }
                        }
                        toolTipText: "展开颜色选择窗口"
                        radiusBg: 0
                    }
                    ColorPicker{
                        id:color_back
                        x:240
                        onActiveFocusItemChanged: {//失去焦点时隐藏
                            if(!activeFocusItem && !menu.active)
                                visible=false
                        }
                        Component.onCompleted: setColor(0.5,0.5,0.5,0.5)
                        onVisibleChanged: {
                            if(visible)color_back_button.text="<"
                            else color_back_button.text=">"
                        }
                    }
                }
            }

            Item{
                x:0
                y:menuItems.height-52
                ImaButton{
                    id:window_top
                    radiusBg: 0
                    width: 25
                    height: 25
                    img:"./images/top.png"
                    checked: true
                    onCheckedChanged: {
                        if(!checked)
                        {
                            img="./images/top_.png"
                            window.flags=Qt.FramelessWindowHint
                        }
                        else
                        {
                            img="./images/top.png"
                            window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                        }
                        //sys_top.checked=checked
                        menu.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "置顶"
                }
                ImaButton{
                    id:time_pauce
                    radiusBg: 0
                    x:25
                    width: 25
                    height: 25
                    img:"./images/pause.png"
                    checked: true
                    onCheckedChanged: {
                        if(!checked)
                            img="./images/pause_.png"
                        else
                            img="./images/pause.png"
                        menu.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "允许暂停"
                }
                ImaButton{
                    id:window_lock
                    radiusBg: 0
                    x:50
                    width: 25
                    height: 25
                    img:"./images/locked_.png"
                    checked: false
                    onCheckedChanged: {
                        if(!checked)
                            img="./images/locked_.png"
                        else
                            img="./images/locked.png"
                        menu.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "锁定"
                }
                ImaButton{
                    id:show_type
                    radiusBg: 0
                    x:75
                    width: 25
                    height: 25
                    img:"./images/s.png"
                    checked: true
                    onCheckedChanged: {
                        if(!checked)
                        {
                            img="./images/s_.png"
                            time_text.type="hh:mm"
                        }
                        else
                        {
                            img="./images/s.png"
                            time_text.type="hh:mm:ss"
                        }
                        menu.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "显示秒"
                }
                ImaButton{
                    radiusBg: 0
                    x:100
                    width: 25
                    height: 25
                    img:"./images/sync_time.png"
                    onClicked:
                    {
                        refresh.running=false
                        timer_set.f=true
                        timer_set.running=true
                        menu.visible=false
                    }
                    toolTipText: "同步时间"
                }
                ImaButton{
                    radiusBg: 0
                    x:125
                    width: 25
                    height: 25
                    img:"./images/reread.png"
                    onClicked:
                    {
                        file.read2("./value.txt")
                        menu.visible=false
                    }
                    toolTipText: "重载数据"
                }
                ImaButton{//清除数据
                    img: "./images/clear_.png"
                    x:150
                    width:25
                    height:25
                    onClicked: {
                        if(img=="./images/clear_.png")
                        {
                            file.source="./is.txt"
                            file.write("false")
                            img="./images/clear.png"
                        }
                        else
                        {
                            file.source="./is.txt"
                            file.write("true")
                            img="./images/clear_.png"
                        }
                        menu.visible=false
                    }
                    toolTipText:"清除数据"
                    radiusBg: 0
                }
                ImaButton{
                    img: "./images/about.png"
                    width:25
                    height:25
                    x:175
                    onClicked: {
                        about.visible=true
                        menu.visible=false
                    }
                    toolTipText:"关于"
                    radiusBg: 0
                    Window{
                        id:about
                        width: 300
                        height: 130
                        minimumHeight: height
                        maximumHeight: height
                        minimumWidth: width
                        maximumWidth: width
                        Image {
                            x:20
                            y:10
                            width: 70
                            height: 70
                            source: "./images/Qt.png"
                        }
                        Text{
                            x:90
                            y:25
                            font.pixelSize: 20
                            text:"Made with Qt6 (qml)"
                        }
                        Text {
                            x:90
                            y:45
                            text: "(Desktop Qt 6.8.3 MinGW 64-bit)"
                        }
                        Cbutton{
                            text:"源代码"
                            font.pixelSize: 16
                            width: 80
                            x:30
                            y:80
                            height: 20
                            onClicked: Qt.openUrlExternally("https://github.com/lazx547/547clock")
                            toolTipText: "打开github"
                        }
                        Cbutton{
                            text:"547官网"
                            font.pixelSize: 16
                            width: 100
                            x:170
                            y:80
                            height: 20
                            onClicked: Qt.openUrlExternally("https://lazx547.github.io")
                            toolTipText: "打开547官网"
                        }
                    }
                }

                Item{
                    y:25
                    ImaButton{
                        radiusBg: 0
                        width: 25
                        height: 25
                        img:"./images/exit.png"
                        danger: true
                        onClicked:
                        {
                            file.save()
                            Qt.quit()
                        }
                        toolTipText: "退出"
                    }
                    ImaButton{//保存按钮
                        width: 25
                        height: 25
                        img: "./images/save.png"
                        x:25
                        onClicked: file.save()
                        toolTipText: "保存"
                        radiusBg: 0
                    }
                    ImaButton{//隐藏按钮
                        width: 25
                        height: 25
                        img: "./images/hide.png"
                        x:50
                        onClicked: {
                            window.visible=false
                            menu.visible=false
                        }
                        toolTipText: "隐藏窗口"
                        radiusBg: 0
                    }
                    ImaButton{//不保存并退出按钮
                        width: 25
                        height: 25
                        img: "./images/exit_not_save.png"
                        x:75
                        onClicked: Qt.exit(0)
                        toolTipText: "不保存并退出"
                        danger:true
                        radiusBg: 0
                    }
                    Cbutton{
                        width: 25
                        height: 25
                        x:100
                        rotation: 90
                        text: "<"
                        font.pixelSize: 25
                        onClicked:
                        {
                            window.y-=1
                        }
                        toolTipText: "窗口上移一单位"
                        radiusBg: 0
                    }
                    Cbutton{
                        width: 25
                        height: 25
                        rotation: 90
                        x:125
                        text: ">"
                        font.pixelSize: 25
                        onClicked:
                        {
                            window.y+=1
                        }
                        toolTipText: "窗口下移一单位"
                        radiusBg: 0
                    }
                    Cbutton{
                        width: 25
                        height: 25
                        x:150
                        text: "<"
                        font.pixelSize: 25
                        onClicked:
                        {
                            window.x-=1
                        }
                        toolTipText: "窗口左移一单位"
                        radiusBg: 0
                    }
                    Cbutton{
                        width: 25
                        height: 25
                        x:175
                        text: ">"
                        font.pixelSize: 25
                        onClicked:
                        {
                            window.x+=1
                        }
                        toolTipText: "窗口右移一单位"
                        radiusBg: 0
                    }
                }
            }
        }
    }
    DragHandler {//按下拖动以移动窗口
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: {
            if (active && window_lock)
            {
                menu.visible=false
                window.startSystemMove()
            }
        }
    }
}
