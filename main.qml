import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Basic
import GFile 1.2
import QtQuick.Dialogs
import Qt.labs.platform
import Qt5Compat.GraphicalEffects

Window {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint//无边框 最上层
    width: winw*win.scale
    height: winh*win.scale
    x:200
    y:200
    color: "#00000000"//背景透明（r,g,b,a）
    opacity: alpSlider.value
    property string s:"hh:mm:ss"//显示模式
    property int winw:140//默认宽度
    property int winh:33//默认高度
    function hidewindows(){
        pick_b.visible=false
        pick_f.visible=false
        pick_d.visible=false
    }
    onWinwChanged: width=winw*win.scale
    onWinhChanged: height=winh*win.scale
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
                     if(true&&!can_s.checked)//如果未锁定
                     {
                         if(wheel.angleDelta.y>0)
                         {
                             win.scale+=0.1
                             window.width=winw*win.scale
                             window.height=winh*win.scale
                         }
                         else
                         {
                             if(window.width>=10){//如果窗口宽度大于30，防止缩放过小时窗口直接消失
                                 win.scale-=0.1
                                 window.width=winw*win.scale
                                 window.height=winh*win.scale
                             }
                         }
                         sb2.setValue((win.scale-0.1)/8)//同时修改“缩放”滚动条位置

                     }
                 }
    }
    Rectangle{
        id:winn
        color: Qt.rgba(pick_b.r,pick_b.g,pick_b.b,pick_b.a)
        border.color: Qt.rgba(pick_d.r,pick_d.g,pick_d.b,Math.max(pick_d.a,1/255))
        border.width: 1.8
        z:-1
        anchors.fill:parent
        radius: 0
    }
    Rectangle {
        id:win
        color: "#00000000"
        Item {
            anchors.fill: parent
            Text{//显示时间
                id: textDateTime
                color: Qt.rgba(pick_f.r,pick_f.g,pick_f.b,pick_f.a)
                text: Qt.formatDateTime(new Date(), s);
                font.pixelSize: 35
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: 0
            }
            Timer{//定时器 刷新时间
                id: timer
                interval: 10 //间隔(单位毫秒=10^-3秒）
                running: false
                repeat: true //重复
                onTriggered:{
                    // if(top_.checked)
                    // {
                    //     window.flags=Qt.FramelessWindowHint
                    //     window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    // }
                    textDateTime.text = Qt.formatDateTime(new Date(), s);
                    if(!yjcd.active && !pick_b.active &&!pick_f.active)
                        yjcd.visible=false
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
            winn.radius=rad_.value*win.height/2
            winn.border.width=f_r.value*win.scale*18
        }
        anchors.fill: parent
        DragHandler {//按下拖动以移动窗口
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active && !can_s.checked)
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
            var a=pick_b.r.toString()+","+pick_b.g.toString()+","+pick_b.b.toString()+","+pick_b.a.toString()+","   //背景颜色
            a+=pick_f.r.toString()+","+pick_f.g.toString()+","+pick_f.b.toString()+","+pick_f.a.toString()+","      //文字颜色
            a+=pick_d.r.toString()+","+pick_d.g.toString()+","+pick_d.b.toString()+","+pick_d.a.toString()+","      //边框颜色
            a+=alpSlider.value.toString()+","                                                                       //透明度
            a+=wid.value.toString()+","                                                                             //宽度
            a+=hei.value.toString()+","                                                                             //高度
            a+=f_r.value.toString()+","                                                                             //边框宽度
            a+=rad_.value.toString()+","                                                                            //圆角大小
            a+=font_size.value.toString()+","                                                                       //字体大小
            a+=textDateTime.anchors.horizontalCenterOffset+","                                                      //文字水平偏移
            a+=textDateTime.anchors.verticalCenterOffset+","                                                        //文字竖直偏移
            a+=f_b.checked+","                                                                                      //是否加粗
            a+=top_.checked+","                                                                                     //是否置顶
            a+=can_pau.checked+","                                                                                  //是否允许暂停
            a+=can_s.checked+","                                                                                    //是否锁定
            a+=show_type.checked+","                                                                                //是否显示秒
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
            var s=file_q.read(),r_,g_,b_,a_
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            pick_b.setColor(r_,g_,b_,a_)                                    //背景颜色
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            pick_f.setColor(r_,g_,b_,a_)                                    //文字颜色
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            pick_d.setColor(r_,g_,b_,a_)                                    //边框颜色
            alpSlider.setValue(Number(s.slice(0,s.indexOf(","))))           //透明度
            s=s.slice(s.indexOf(",")+1,s.length)
            wid.setValue(s.slice(0,s.indexOf(",")))                         //宽度
            s=s.slice(s.indexOf(",")+1,s.length)
            hei.setValue(s.slice(0,s.indexOf(",")))                         //高度
            s=s.slice(s.indexOf(",")+1,s.length)
            f_r.setValue(s.slice(0,s.indexOf(",")))                         //边框宽度
            s=s.slice(s.indexOf(",")+1,s.length)
            rad_.setValue(s.slice(0,s.indexOf(",")))                        //圆角大小
            s=s.slice(s.indexOf(",")+1,s.length)
            font_size.setValue(s.slice(0,s.indexOf(",")))                   //字体大小
            s=s.slice(s.indexOf(",")+1,s.length)                            //文字水平偏移
            textDateTime.anchors.horizontalCenterOffset=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)                            //文字竖直偏移
            textDateTime.anchors.verticalCenterOffset=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            f_b.checked=s.slice(0,s.indexOf(","))=="true" ? true:false      //是否加粗
            s=s.slice(s.indexOf(",")+1,s.length)
            top_.checked=s.slice(0,s.indexOf(","))=="true" ? true:false     //是否置顶
            s=s.slice(s.indexOf(",")+1,s.length)
            can_pau.checked=s.slice(0,s.indexOf(","))=="true" ? true:false  //是否允许暂停
            s=s.slice(s.indexOf(",")+1,s.length)
            can_s.checked=s.slice(0,s.indexOf(","))=="true" ? true:false    //是否锁定
            s=s.slice(s.indexOf(",")+1,s.length)
            show_type.checked=s.slice(0,s.indexOf(","))=="true" ? true:false//是否显示秒
            a=1
        }
    }
    SystemTrayIcon {
        visible: true
        icon.source: "qrc:/sys_Tray.png"
        id:tray
        menu: Menu {
            MenuItem {
                id:sys_sh
                text: qsTr("隐藏窗口")
                onTriggered: {
                    if(sys_sh.text=="显示窗口")
                    {
                        window.visible=true
                        sys_sh.text="隐藏窗口"
                    }
                    else
                    {
                        window.visible=false
                        sys_sh.text="显示窗口"
                    }
                }
            }
            MenuItem {
                text: qsTr("退出")
                onTriggered: Qt.quit()
            }
        }
    }
    Window{//右键菜单
        id:yjcd
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint//无边框 最上层
        width: 204
        height: 324
        color: "#00000000"
        property bool pick_:false
        onActiveFocusItemChanged: {//失去焦点时隐藏
            if(!activeFocusItem && !pick_b.active && !pick_f.active && !pick_d.active)
                visible=false

        }
        Rectangle{
            anchors.fill: parent
            border.color: "#80808080"
            border.width: 2
        }

        Rectangle
        {
            transformOrigin: Item.TopLeft
            width: 200
            height: 320
            id:cd_
            x:2
            y:2
            Item{
                id:move
                y:parent.height-50
                ImaButton{//关闭按钮
                    y:25
                    width: 25
                    height: 25
                    img: "qrc:/images/exit.png"
                    onClicked: {
                        file_q.save()
                        Qt.exit(0)
                    }
                    toolTipText: qsTr("保存并退出")
                    danger:true
                    radiusBg: 0
                }
                ImaButton{//保存按钮
                    y:25
                    width: 25
                    height: 25
                    img: "qrc:/images/save.png"
                    x:25
                    onClicked: file_q.save()
                    toolTipText: qsTr("保存")
                    radiusBg: 0
                }
                ImaButton{//隐藏按钮
                    y:25
                    width: 25
                    height: 25
                    img: "qrc:/images/hide.png"
                    x:50
                    onClicked: {
                        sys_sh.text="显示窗口"
                        window.visible=false
                        yjcd.visible=false
                    }
                    toolTipText: qsTr("隐藏窗口")
                    radiusBg: 0
                }
                ImaButton{//不保存并退出按钮
                    y:25
                    width: 25
                    height: 25
                    img: "qrc:/images/exit_not_save.png"
                    x:75
                    onClicked: Qt.exit(0)
                    toolTipText: qsTr("不保存并退出")
                    danger:true
                    radiusBg: 0
                }
                Movetool{//窗口移动工具
                    y:25
                    x:100
                    window:window
                }
                ImaButton{//清除数据
                    img: "qrc:/images/clear_.png"
                    x:150
                    width:25
                    height:25
                    onClicked: {
                        if(img=="qrc:/images/clear_.png")
                        {
                            file_q.source="./is.1"
                            file_q.write("false")
                            img="qrc:/images/clear.png"
                        }
                        else
                        {
                            file_q.source="./is.1"
                            file_q.write("true")
                            img="qrc:/images/clear_.png"
                        }
                        yjcd.visible=false
                    }
                    toolTipText:"清除数据"
                    radiusBg: 0
                }
                ImaButton{//同步时间
                    id:time_set
                    img: "qrc:/images/sync_time.png"
                    width:25
                    height:25
                    x:100
                    onClicked:  {
                        timer.running=false
                        timer_set.f=true
                        timer_set.running=true
                        yjcd.visible=false
                    }
                    toolTipText:"同步时间"
                    radiusBg: 0
                }
                ImaButton{
                    id:date_reread
                    width: 25
                    height: 25
                    x:125
                    img:"qrc:/images/reread.png"
                    onClicked: {
                        file_q.read2("./value.1")
                        yjcd.visible=false
                    }
                    toolTipText:"重载数据"
                    radiusBg: 0
                }
                ImaButton{
                    img: "qrc:/images/about.png"
                    width:25
                    height:25
                    x:175
                    onClicked: {
                        about.visible=true
                        yjcd.visible=false
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
                        }
                        Cbutton{
                            text:"547官网"
                            font.pixelSize: 16
                            width: 100
                            x:170
                            y:80
                            height: 20
                            onClicked: Qt.openUrlExternally("https://lazx547.github.io")
                        }
                    }
                }
                ImaButton{//是否显示在最上层
                    id:top_
                    width: 25
                    height: 25
                    x:0
                    img:"qrc:/images/top.png"
                    checked: true
                    onCheckedChanged: {
                        if(!checked)
                        {
                            img="qrc:/images/top_.png"
                            window.flags=Qt.FramelessWindowHint
                        }
                        else
                        {
                            img="qrc:/images/top.png"
                            window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                        }
                        yjcd.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "显示在最上层"
                    radiusBg: 0
                }
                ImaButton{//是否允许暂停
                    id:can_pau
                    width: 25
                    height: 25
                    x:25
                    img:"qrc:/images/pause.png"
                    checked: true
                    onCheckedChanged: {
                        if(!checked)
                            img="qrc:/images/pause_.png"
                        else
                            img="qrc:/images/pause.png"
                        yjcd.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "是否允许暂停"
                    radiusBg: 0
                }
                ImaButton{//锁定
                    id:can_s
                    width: 25
                    height: 25
                    x:50
                    img:"qrc:/images/locked_.png"
                    checked: false
                    onCheckedChanged: {
                        if(!checked)
                            img="qrc:/images/locked_.png"
                        else
                            img="qrc:/images/locked.png"
                        yjcd.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "锁定"
                    radiusBg: 0
                }
                ImaButton{//是否显示秒
                    id:show_type
                    width: 25
                    height: 25
                    x:75
                    img:"qrc:/images/s.png"
                    checked: true
                    onCheckedChanged: {
                        if(!checked)
                        {
                            img="qrc:/images/s_.png"
                            s="hh:mm"
                        }
                        else
                        {
                            img="qrc:/images/s.png"
                            s="hh:mm:ss"
                        }
                        textDateTime.text=Qt.formatDateTime(new Date(), s);
                        yjcd.visible=false
                    }
                    onClicked: checked=!checked
                    toolTipText: "是否显示秒"
                    radiusBg: 0
                }
                // Cbutton{
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
                // Cbutton{
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

        Item{
            id:cd
            x:2
            y:2
            Item{
                id:appea
                y:0
                Item{
                    id: alpPickerItem
                    Text{
                        text:"透明度"
                        font.pixelSize: 14
                        y:-2
                    }
                    Item {
                        id: alpPickerItem_
                        width: 130
                        height: 15
                        x:45
                        y:0
                        Grid {
                            id: alphaPicker
                            anchors.fill: parent
                            rows: 4
                            columns: 29
                            clip: true

                            property real cellWidth: width / columns
                            property real cellHeight: height / rows

                            Repeater {
                                model: parent.columns * parent.rows

                                Rectangle {
                                    width: alphaPicker.cellWidth
                                    height: width
                                    color: (index % 2 == 0) ? "gray" : "transparent"
                                }
                            }
                        }
                        Rectangle {
                            anchors.fill: parent
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 1.0; color: "#ff000000" }
                                GradientStop { position: 0.0; color: "#00ffffff" }
                            }
                        }
                        Rectangle {
                            id: alpSlider
                            x: parent.width - width
                            width: height
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
                            color: Qt.rgba(0.1, 0.1, 0.1, (value + 1.0) / 2.0)
                            border.color: "#e6e6e6"
                            border.width: 2
                            scale: 0.9
                            property real value: Math.max(x / (parent.width - width)*0.99+0.01,0.01)
                            function setValue(vl){
                                alpSlider.x = Math.max(0,vl*(alpPickerItem_.width-alpSlider.width))
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 1
                                color: "transparent"
                                border.color: "white"
                                border.width: 1
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            function handleCursorPos(x) {
                                let halfWidth = alpSlider.width * 0.5;
                                alpSlider.x = Math.max(0, Math.min(width, x + halfWidth) - alpSlider.width);
                            }
                            onPressed: (mouse) => {
                                           handleCursorPos(mouse.x, mouse.y);
                                       }

                            onPositionChanged: (mouse) => handleCursorPos(mouse.x);
                        }
                    }
                    Rectangle{
                        x:175
                        y:0
                        width: 25
                        height: 15
                        color:Qt.rgba(0.8,0.8,0.8)
                        Text{
                            anchors.fill: parent
                            id:vr
                            text:(alpSlider.value * 255).toFixed(0);
                            font.pixelSize: 14
                            horizontalAlignment:Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Item{//调整大小
                    id:scale_
                    y:alpPickerItem.y+20
                    CscrollBar{//调整缩放
                        y:0
                        text:"缩放"
                        id:sb2
                        reset:0.1
                        step:0.0001
                        minValue: 10
                        maxValue: 8100
                        Component.onCompleted: setValue(0.1)
                        onValueChanged: {
                            win.scale=value*8+0.1
                            window.width=winw*win.scale
                            window.height=winh*win.scale
                        }
                    }
                    CscrollBar{//调整宽度
                        y:20
                        text:"宽度"
                        id:wid
                        reset:0.28
                        step:0.007
                        minValue: 100
                        maxValue: 240
                        onValueChanged: {
                            winw=value*140*win.scale+100
                            window.width=winw*win.scale
                        }
                        Component.onCompleted: setValue(0.19)
                    }
                    CscrollBar{//调整高度
                        y:40
                        text:"高度"
                        id:hei
                        reset:0.09
                        step:0.03
                        minValue: 30
                        maxValue: 63
                        onValueChanged: {
                            winh=value*33*win.scale+30
                            window.height=winh*win.scale
                        }
                        Component.onCompleted: setValue(0.09)
                    }
                }

                Item{//调整字体
                    id:font_
                    y:scale_.y+65
                    Text{
                        text:"字体"
                        font.pixelSize: 18
                    }
                    CscrollBar{//调整字号
                        id:font_size
                        y:25
                        reset:0.31
                        text: "字号"
                        Component.onCompleted: setValue(0.31)
                        step: 0.01
                        onValueChanged: {
                            textDateTime.font.pixelSize=value*100
                        }
                    }

                    Item {//调整文字
                        y:3
                        x:80
                        ImaButton{//字体是否加粗
                            img:"qrc:/images/bord_.png"
                            width: 20
                            height: 20
                            id:f_b
                            checked: false
                            onClicked: checked=!checked
                            onCheckedChanged: {
                                textDateTime.font.bold=checked
                                img=checked? "qrc:/images/bord.png":"qrc:/images/bord_.png"
                            }
                            toolTipText: "文字加粗"
                            radiusBg: 0
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
                                textDateTime.anchors.verticalCenterOffset-=1
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
                                textDateTime.anchors.verticalCenterOffset+=1
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
                                textDateTime.anchors.horizontalCenterOffset-=1
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
                                textDateTime.anchors.horizontalCenterOffset+=1
                            }
                            toolTipText: "文字右移一个单位"
                            radiusBg: 0
                        }
                        ImaButton{
                            width: 20
                            height: 20
                            x:100
                            img:"qrc:/images/reset.png"
                            onClicked: {
                                textDateTime.anchors.horizontalCenterOffset=0
                                textDateTime.anchors.verticalCenterOffset=0
                            }
                            toolTipText: "重置文字位置"
                            radiusBg: 0
                        }
                    }
                }
                Item{//调整边框
                    y:font_.y+40
                    id:bord
                    Text{
                        y:2
                        text:"边框"
                        font.pixelSize: 18
                    }
                    CscrollBar{//调整边框大小
                        id:f_r
                        y:25
                        text:"大小"
                        onValueChanged: {
                            winn.border.width=value*win.scale*18
                        }
                        Component.onCompleted: setValue(1.8/20)
                    }
                    CscrollBar{//调整圆角大小
                        y:f_r.y+20
                        id:rad_
                        text:"圆角"
                        onValueChanged: {
                            winn.radius=value*winn.height/2
                        }
                        Component.onCompleted: setValue(0.31)
                    }
                }
                Rectangle{//调整颜色
                    id:colo
                    y:bord.y+65
                    Text{
                        text:"颜色"
                        font.pixelSize: 18
                    }
                    Item{
                        id:ys
                        Cbutton{
                            id:ys_f
                            x:cd_.width-40
                            width: 40
                            height: 20
                            text:"粉色"
                            font.pixelSize: 14
                            onClicked: {
                                pick_f.setColor(1,162/255,210/255,1)
                                pick_d.setColor(1,162/255,210/255,1)
                                pick_b.setColor(0.2,0.2,0.2,0.2)
                            }
                            toolTipText: "预设的颜色搭配"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:ys_s
                            x:cd_.width-80
                            width: 40
                            height: 20
                            text:"深色"
                            font.pixelSize: 14
                            onClicked: {
                                pick_f.setColor(1,1,1,1)
                                pick_d.setColor(1,1,1,1)
                                pick_b.setColor(0,0,0,0.6)
                            }
                            toolTipText: "预设的颜色搭配"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:ys_q
                            x:cd_.width-120
                            width: 40
                            height: 20
                            text:"浅色"
                            font.pixelSize: 14
                            onClicked: {
                                pick_f.setColor(0,0,0,1)
                                pick_d.setColor(0,0,0,1)
                                pick_b.setColor(1,1,1,0.6)
                            }
                            toolTipText: "预设的颜色搭配"
                            radiusBg: 0
                        }
                    }

                    Item{
                        y:20
                        Text{
                            text:"文字:"
                            height: 60
                            font.pixelSize: 16
                        }
                        Cbutton{
                            id:f_copy_d
                            x:cd_.width-130
                            width: 55
                            height: 20
                            text:"同边框"
                            font.pixelSize: 14
                            onClicked: {
                                pick_f.setColor(pick_d.r,pick_d.g,pick_d.b,pick_d.a)
                            }
                            toolTipText: "从边框复制颜色"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:f_copy_f
                            x:cd_.width-75
                            width: 55
                            height: 20
                            text:"同背景"
                            font.pixelSize: 14
                            onClicked: {
                                pick_f.setColor(pick_b.r,pick_b.g,pick_b.b,pick_b.a)
                            }
                            toolTipText: "从文字复制颜色"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:pick_f_b
                            x:cd_.width-20
                            width: 20
                            height: 20
                            text:">"
                            onClicked: {
                                if(text==">")
                                {
                                    pick_f.x=yjcd.x+cd_.width
                                    pick_f.y=yjcd.y+appea.y+colo.y+20
                                    hidewindows()
                                    pick_f.visible=true
                                }
                            }
                            toolTipText: "展开颜色选择窗口"
                            radiusBg: 0
                        }
                        ColorPicker{
                            id:pick_f
                            x:240
                            onActiveFocusItemChanged: {//失去焦点时隐藏
                                if(!activeFocusItem && !yjcd.active)
                                    visible=false
                            }
                            Component.onCompleted: setColor(0,0,0,1)
                            onVisibleChanged: {
                                if(visible)pick_f_b.text="<"
                                else pick_f_b.text=">"
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
                            id:d_copy_f
                            x:cd_.width-130
                            width: 55
                            height: 20
                            text:"同文字"
                            font.pixelSize: 14
                            onClicked: {
                                pick_d.setColor(pick_f.r,pick_f.g,pick_f.b,pick_f.a)
                            }
                            toolTipText: "从文字复制颜色"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:d_copy_d
                            x:cd_.width-75
                            width: 55
                            height: 20
                            text:"同背景"
                            font.pixelSize: 14
                            onClicked: {
                                pick_d.setColor(pick_b.r,pick_b.g,pick_b.b,pick_b.a)
                            }
                            toolTipText: "从背景复制颜色"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:pick_d_b
                            x:cd_.width-20
                            width: 20
                            height: 20
                            text:">"
                            onClicked: {
                                if(text===">")
                                {
                                    pick_d.x=yjcd.x+cd_.width
                                    pick_d.y=yjcd.y+appea.y+colo.y+40
                                    hidewindows()
                                    pick_d.visible=true
                                }
                            }
                            toolTipText: "展开颜色选择窗口"
                            radiusBg: 0
                        }
                        ColorPicker{
                            id:pick_d
                            x:240
                            onActiveFocusItemChanged: {//失去焦点时隐藏
                                if(!activeFocusItem && !yjcd.active)
                                    visible=false
                            }
                            Component.onCompleted: setColor(0,0,0,1)
                            onVisibleChanged: {
                                if(visible)pick_d_b.text="<"
                                else pick_d_b.text=">"
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
                            id:b_copy_f
                            x:cd_.width-130
                            width: 55
                            height: 20
                            text:"同文字"
                            font.pixelSize: 14
                            onClicked: {
                                pick_b.setColor(pick_f.r,pick_f.g,pick_f.b,pick_f.a)
                            }
                            toolTipText: "从文字复制颜色"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:b_copy_d
                            x:cd_.width-75
                            width: 55
                            height: 20
                            text:"同边框"
                            font.pixelSize: 14
                            onClicked: {
                                pick_b.setColor(pick_d.r,pick_d.g,pick_d.b,pick_d.a)
                            }
                            toolTipText: "从边框复制颜色"
                            radiusBg: 0
                        }
                        Cbutton{
                            id:pick_b_b
                            x:cd_.width-20
                            width: 20
                            height: 20
                            text:">"
                            onClicked: {
                                if(!pick_b.visible)
                                {
                                    pick_b.x=yjcd.x+cd_.width
                                    pick_b.y=yjcd.y+appea.y+colo.y+60
                                    pick_f.visible=false
                                    pick_b.visible=true
                                }
                            }
                            toolTipText: "展开颜色选择窗口"
                            radiusBg: 0
                        }

                        ColorPicker{
                            id:pick_b
                            onActiveFocusItemChanged: {//失去焦点时隐藏
                                if(!activeFocusItem && !yjcd.active)
                                    visible=false
                            }
                            Component.onCompleted: setColor(1,1,1,1)
                            onVisibleChanged: {
                                if(visible)pick_b_b.text="<"
                                else pick_b_b.text=">"
                            }
                        }
                    }
                }
            }
        }
    }
}
