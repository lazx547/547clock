import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt.labs.platform
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic
import GFile 1.2
Window{
    id: window
    visible: true
    flags: Qt.WindowStaysOnTopHint
    visibility: Window.FullScreen
    color: "transparent"
    opacity: window_opa.value*0.99+0.01

    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height

    function restart(){
        file.save()
        mstg_window.save()
        $reload.win()
    }
    function show(){
        file.read2("./value.txt")
        mstg_window.read()
        window.visible=true
    }
    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
        onClicked:{
            if( mstg_window.visible)
            {
                mstg_window.visible=false
                mstg_button.text="更多  >"
            }
            else menu.visible=!menu.visible
        }
        onWheel:(wheel)=>{
                    if(true)
                    {
                        if(wheel.angleDelta.y>0) win.scale+=0.1
                        else if(wheel.angleDelta.y<0)
                        {
                            if(win.scale>0.2)  win.scale-=0.1
                        }
                        window_scale.setValue((win.scale-0.01)/20.9)
                        win.x=(sys_width-win.width*win.scale)/2
                        win.y=(sys_height-win.height*win.scale)/2
                    }
                }
    }
    Timer{//初始化计时器
        id:timer_set
        interval: 10
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
                        mstg_window.read()
                        win.scale=sys_width/win.width
                        win.x=(sys_width-win.width*win.scale)/2
                        win.y=(sys_height-win.height*win.scale)/2
                    }
                }
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        color:Qt.rgba(color_back.r,color_back.g,color_back.b,color_back.a)
    }

    Rectangle{//文字
        id:win
        x:(sys_width-width*scale)/2
        y:(sys_height-height*scale)/2
        transformOrigin: Item.TopLeft
        width:window_width.value*240+40
        height:window_height.value*100+10
        scale:window_scale.value*80.9+0.01
        border.width: border_width.value*win.height/2
        radius:border_radiu.value*win.height/2
        border.color:Qt.rgba(color_border.r,color_border.g,color_border.b,color_border.a)
        color: "transparent"
        Text{
            id:time_text
            anchors.centerIn:  parent
            property string type:"aahh:mm:ss"
            font.pixelSize:text_size.value*100+5
            color:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            Timer{
                id:refresh
                interval: 10
                property int auto_save_delt:0
                onTriggered:
                {
                    if(auto_save.checked)
                    {
                        auto_save_delt++
                        if(auto_save_delt==7200)
                        {
                            auto_save_delt=0
                            file.save()
                        }
                    }

                    if(h_type.checked) time_text.text=Qt.formatDateTime(new Date(), h_type_t.text)
                    else{
                        var h,m,s,y,M,z,d;
                        h=Number(Qt.formatDateTime(new Date(),"hh"))
                        m=Number(Qt.formatDateTime(new Date(),"mm"))
                        s=Number(Qt.formatDateTime(new Date(),"ss"))+delT.delT
                        z=Qt.formatDateTime(new Date(),"zzz")
                        if(s<0)
                        {
                            m--
                            s+=60
                            if(m<0)
                            {
                                h--
                                m+=60
                                if(h<0)
                                {
                                    h+=24
                                }
                            }
                        }
                        else if(s>=60)
                        {
                            m++
                            s-=60
                            if(m>=60)
                            {
                                h++
                                m-=60
                                if(h>=24)
                                {
                                    h-=24
                                }
                            }
                        }
                        if(s<10)
                            s="0"+s
                        if(m<10)
                            m="0"+m
                        if(h<10)
                            h="0"+h
                        time_text.text=h+":"+m
                        if(show_type_ss.checked)
                        {
                            time_text.text+=":"+s
                            if(show_type_zzz.checked)
                                time_text.text+=":"+z
                        }
                    }
                    if(fresh_top.checked)
                    {
                        window.flags=Qt.FramelessWindowHint
                        window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    }
                    win.x=(sys_width-win.width*win.scale)/2
                    win.y=(sys_height-win.height*win.scale)/2
                }
                running: false
                repeat: true
            }
        }
    }
    GFile{//文件操作
        id:file
        function save(){//正常保存
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
            a=1
        }
    }
    Item{//右键菜单窗口
        id:menu
        visible:false
        width: 204
        height:sys_height+4
        x:sys_width-202
        y:-2
        Rectangle{//右键菜单窗口背景
            id:menu_back
            width: menu.width
            height:menu.height
            border.width: 2
            border.color: "#80808080"
            transformOrigin: Item.TopLeft
        }
        Item{//右键菜单
            id:menuItems
            x:menu_back.border.width
            y:menu_back.border.width
            width: menu.width-menu_back.border.width
            height:menu.height-menu_back.border.width
            ScrollView{
                width: 200
                height: menu.height-75
                contentHeight: subItem.height

                Item{
                    id:subItem
                    height: 930
                    y:5
                    Item{//窗口
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
                            maxValue: 2100
                            minValue: 10
                            step:0.00047
                            Component.onCompleted: setValue(0.047)
                            onValueChanged: win.scale=value*20.9+0.01
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
                            text:"高度"
                            maxValue: 110
                            minValue: 10
                            reset:0.3
                            Component.onCompleted: setValue(reset)
                        }
                    }
                    Item{//文字
                        id:text_set
                        y:85
                        Text{
                            text:"文字"
                            font.pixelSize:18
                        }
                        Item{
                            y:3
                            x:menuItems.width-122
                            ImaButton{//加粗
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
                                radiusBg: 0
                            }
                            ImaButton{//重置
                                width: 20
                                height: 20
                                x:100
                                img:"./images/reset.png"
                                onClicked: {
                                    time_text.anchors.horizontalCenterOffset=0
                                    time_text.anchors.verticalCenterOffset=0
                                }
                                radiusBg: 0
                            }

                        }
                        CscrollBar{//字体大小
                            y:25
                            id:text_size
                            minValue: 5
                            maxValue: 105
                            reset:0.32
                            Component.onCompleted: setValue(reset)
                            text:"大小"
                        }
                    }
                    Item{//边框
                        id:border_set
                        y:130
                        Text{
                            text:"边框"
                            font.pixelSize:18
                        }
                        CscrollBar{//边框大小
                            y:25
                            id:border_width
                            minValue:0
                            maxValue:win.height/2
                            step:1/(win.width/2)
                            reset:0.1
                            Component.onCompleted: setValue(reset)
                            text:"大小"
                        }
                        CscrollBar{//圆角大小
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
                    Item{//颜色
                        id:color_set
                        y:195
                        Text{
                            text:"颜色"
                            font.pixelSize:18
                        }
                        Item{//文字
                            y:20
                            Text{
                                text:"文字:"
                                height: 60
                                font.pixelSize: 16
                            }
                            Cbutton{
                                x:menuItems.width-112
                                width: 55
                                height: 20
                                text:"同边框"
                                font.pixelSize: 14
                                onClicked: {
                                    color_text.setColor(color_border.r,color_border.g,color_border.b,color_border.a)
                                }
                                radiusBg: 0
                            }
                            Cbutton{
                                x:menuItems.width-57
                                width: 55
                                height: 20
                                text:"同背景"
                                font.pixelSize: 14
                                onClicked: {
                                    color_text.setColor(color_back.r,color_back.g,color_back.b,color_back.a)
                                }
                                radiusBg: 0
                            }
                            ColorPickerItem{
                                id:color_text
                                y:21
                                Component.onCompleted: setColor(0,0,0,1)
                            }
                        }
                        Item{//边框
                            y:125
                            Text{
                                text:"边框:"
                                height: 60
                                font.pixelSize: 16
                            }
                            Cbutton{
                                x:menuItems.width-112
                                width: 55
                                height: 20
                                text:"同文字"
                                font.pixelSize: 14
                                onClicked: {
                                    color_border.setColor(color_text.r,color_text.g,color_text.b,color_text.a)
                                }
                                radiusBg: 0
                            }
                            Cbutton{
                                x:menuItems.width-57
                                width: 55
                                height: 20
                                text:"同背景"
                                font.pixelSize: 14
                                onClicked: {
                                    color_text.setColor(color_back.r,color_back.g,color_back.b,color_back.a)
                                }
                                radiusBg: 0
                            }
                            ColorPickerItem{
                                id:color_border
                                y:21
                                Component.onCompleted: setColor(0.133,0.133,0.133,0.75)
                            }
                        }
                        Item{//背景
                            y:230
                            Text{
                                text:"背景:"
                                height: 60
                                font.pixelSize: 16
                            }
                            Cbutton{
                                x:menuItems.width-112
                                width: 55
                                height: 20
                                text:"同文字"
                                font.pixelSize: 14
                                onClicked: {
                                    color_back.setColor(color_text.r,color_text.g,color_text.b,color_text.a)
                                }
                                radiusBg: 0
                            }
                            Cbutton{
                                x:menuItems.width-57
                                width: 55
                                height: 20
                                text:"同边框"
                                font.pixelSize: 14
                                onClicked: {
                                    color_back.setColor(color_border.r,color_border.g,color_border.b,color_border.a)
                                }
                                radiusBg: 0
                            }
                            ColorPickerItem{
                                id:color_back
                                y:21
                                Component.onCompleted: setColor(0.5,0.5,0.5,0.5)
                            }
                        }
                    }
                    Item{//存档
                        id:saves_button
                        y:530
                        Text{
                            text:"存档"
                            font.pixelSize:18
                        }
                        Item {
                            id: saves_window
                            width: 200
                            height: (menu.height-645)>=400 ? (menu.height-645) : 400
                            y:25
                            transformOrigin: Item.TopLeft
                            Rectangle{
                                anchors.fill: parent
                                border.width: 2
                                border.color: "#80808080"

                            }
                            Rectangle{
                                x:2
                                y:4
                                TextArea{
                                    id:save_text
                                    x:2
                                    y:1
                                    width: 120
                                    height: 25
                                    color: "black"
                                    padding:2
                                    font.pixelSize: 18
                                    background:Rectangle{
                                        anchors.fill: parent
                                        border.width: 1
                                        border.color: "#80808080"
                                    }
                                    onTextChanged: {
                                        if(text.length>5)
                                            text=text.slice(0,5)
                                        if(text=="") save_new.enabled=false
                                        else{
                                            var a=false
                                            for(var i=0;i<saves.sis.length;i++)
                                                if(saves.sis[i].num==text)
                                                {
                                                    save_new.enabled=false
                                                    a=true
                                                    break
                                                }
                                            if(!a)
                                                save_new.enabled=true
                                        }
                                    }

                                }

                                Cbutton{
                                    x:135
                                    width: 60
                                    text:"保存"
                                    radiusBg: 0
                                    id:save_new
                                    enabled: false
                                    onClicked: {
                                        enabled=false
                                        file.source="./file/saves/"+save_text.text+".txt"
                                        file.save2(file.source)
                                        var Csaves=Qt.createComponent("./CSaveItem.qml"),im
                                        saves.sis.push(im=Csaves.createObject(saves))
                                        im.file=file
                                        im.par=saves
                                        im.n=saves.sis.length
                                        im.num=save_text.text
                                        im.y=(im.n-1)*50
                                        im.type=false
                                        im.parent=saves
                                        saves.height=50*im.n
                                        file.source="./file/saves/num.txt"
                                        var s=saves.sis.length+","
                                        for(var i=0;i<saves.sis.length;i++)
                                            s+=saves.sis[i].num+","
                                        file.write(s)
                                    }
                                }
                            }
                            ScrollView{
                                x:2
                                y:35
                                width: 200
                                height:saves_window.height-41
                                contentHeight: saves.height
                                id:saves_scoll
                                Item{
                                    width: 200
                                    id:saves
                                    property var sis:[]
                                    function remove(n){
                                        n--
                                        sis[n].destroy()
                                        var i,s
                                        for(i=n;i<sis.length-1;i++)
                                        {
                                            sis[i]=sis[i+1]
                                            sis[i].n-=1
                                            sis[i].y-=50
                                        }
                                        sis.pop()
                                        saves.height-=50
                                        s=sis.length+","
                                        for(i=0;i<sis.length;i++)
                                            s+=sis[i].num+","
                                        file.source="./file/saves/num.txt"
                                        file.write(s)
                                    }
                                }

                                Component.onCompleted: {
                                    file.source="./file/saves/num.txt"
                                    var s=file.read()
                                    var a=Number(s.slice(0,s.indexOf(","))),im
                                    var Csaves=Qt.createComponent("./CSaveItem.qml")
                                    for(var n=1;n<=a;n++)
                                    {
                                        saves.sis.push(im=Csaves.createObject(saves))
                                        im.file=file
                                        im.par=saves
                                        im.n=n
                                        im.type=false
                                        s=s.slice(s.indexOf(",")+1,s.length)
                                        im.num=s.slice(0,s.indexOf(","))
                                        im.y=(n-1)*50
                                        im.parent=saves
                                    }
                                    saves.height=50*a
                                }
                            }
                        }
                    }
                }
            }

            Item{//高级设置
                y:menuItems.height-75
                Text{
                    text:"设置"
                    font.pixelSize:18
                }
                Cbutton{
                    text:"窗口模式"

                    width:70
                    height: 20
                    x:50
                    y:2
                    font.pixelSize: 13
                    onClicked: {
                        restart(1)
                        /*
                        file.source="./run.ini"
                        file.write("fullscreen")
                        file.restart()*/
                    }
                }
                Cbutton{
                    id:mstg_button
                    x:135
                    y:-1
                    width: 65
                    height: 24
                    text:"更多  >"
                    font.pixelSize: 15
                    onClicked: {
                        if(text==="更多  >")
                        {
                            mstg_window.x=menu.x+menu.width
                            mstg_window.y=menu.y
                            if(mstg_window.x+mstg_window.width>sys_width) mstg_window.x-=menu.width+mstg_window.width
                            mstg_window.visible=true
                            text="更多  <"
                        }
                        else
                            text="更多  >"
                    }
                    Window {
                        id: mstg_window
                        width: 204+saves_scoll.effectiveScrollBarWidth
                        height: menu.height
                        flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                        color: "#11111100"
                        onActiveFocusItemChanged: {//失去焦点时隐藏
                            if(!activeFocusItem)
                            {
                                visible=false
                                mstg_button.text="更多  >"
                            }
                        }
                        function save(){
                            file.source="./mstg.ini"
                            file.write(delT.value+","+h_type_t.text+","+h_type.checked+","+show_type_ss.checked+","+show_type_zzz.checked+","+auto_save.checked+",")
                        }
                        function read(){
                            file.source="./mstg.ini"
                            var s=file.read()
                            delT.setValue(s.slice(0,s.indexOf(",")))
                            s=s.slice(s.indexOf(",")+1,s.length)
                            h_type_t.text=s.slice(0,s.indexOf(","))
                            s=s.slice(s.indexOf(",")+1,s.length)
                            h_type.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
                            s=s.slice(s.indexOf(",")+1,s.length)
                            show_type_ss.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
                            s=s.slice(s.indexOf(",")+1,s.length)
                            show_type_zzz.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
                            s=s.slice(s.indexOf(",")+1,s.length)
                            auto_save.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
                        }

                        Rectangle{
                            anchors.fill: parent
                            border.width: 2
                            border.color: "#80808080"
                        }
                        Item{
                            x:2
                            y:2
                            ScrollView{
                                id:mstg_sv
                                width: 200+saves_scoll.effectiveScrollBarWidth
                                height: menu.height-4
                                contentHeight: 400
                                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                                Rectangle{
                                    height: 400
                                    CscrollBar{
                                        id:delT
                                        text: "时差"
                                        minValue: -60
                                        maxValue: 60
                                        Component.onCompleted: setValue(0.5)
                                        reset:0.5
                                        property int delT:value*120-60
                                    }
                                    Rectangle{
                                        y:20
                                        Text{
                                            text:"显示模式"
                                            font.pixelSize: 15
                                        }
                                        CCheckBox{
                                            id:show_type_ss
                                            height: 16
                                            x:80
                                            transformOrigin: Item.TopLeft
                                            font.pixelSize: 15
                                            text:"秒"
                                        }
                                        CCheckBox{
                                            id:show_type_zzz
                                            enabled: show_type_ss.checked
                                            height: 16
                                            x:120
                                            transformOrigin: Item.TopLeft
                                            font.pixelSize: 15
                                            text:"毫秒"
                                        }
                                    }
                                    Item{
                                        y:40
                                        CCheckBox{
                                            id:auto_save
                                            height: 16
                                            transformOrigin: Item.TopLeft
                                            font.pixelSize: 15
                                            text:"自动保存"
                                        }
                                        ProgreBar{
                                            id:auto_save_pb
                                            x:80
                                            width: 100
                                            percent: refresh.auto_save_delt/7200
                                        }
                                    }

                                    Rectangle{
                                        y:60
                                        Text{
                                            x:2
                                            text:"高级显示模式:"
                                            font.pixelSize: 15
                                        }
                                        CCheckBox{
                                            id:h_type
                                            x:90
                                            y:-1
                                            font.pixelSize: 11
                                            text:"启用(不兼容时差)"
                                        }
                                        TextArea{
                                            id:h_type_t
                                            x:2
                                            y:20
                                            width: 196
                                            height: 20
                                            text:"hh:mm:ss"
                                            color: "black"
                                            padding:0
                                            font.pixelSize: 15
                                            background:Rectangle{
                                                anchors.fill: parent
                                                border.width: 1
                                                border.color: "#80808080"
                                            }
                                        }
                                        Rectangle{
                                            x:2
                                            y:42
                                            width: 196
                                            height: 177
                                            TextArea{
                                                padding:0
                                                font.pixelSize:12
                                                property string tex:"d 日 (1-31)       dd日 (01-31)\nddd 星期 (Mon-Sun)\ndddd 星期 (Monday-Sunday)\nM 月 (1-12)      MM 月 (01-12)\nMMM 月 (Jan-Dec)\nMMMM 月 (January-December)\nyy 年 (00-99)    yyyy 年\nh 小时 (0-23)    hh 小时 (00-23)\nm 分钟 (0-59)   mm 分钟 (00-59)\ns 秒 (0-59)        ss 秒 (00-59)\nz 毫秒 (0-999)   zzz 毫秒(000-999)"
                                                text:tex
                                                background:Rectangle{
                                                    anchors.fill: parent
                                                    border.width: 1
                                                    border.color: "#80808080"
                                                }
                                                onTextChanged: text=tex
                                            }
                                        }
                                    }
                                    Cbutton{
                                        width: 190
                                        height: 16
                                        y:280
                                        font.pixelSize: 13
                                        text:"显示任务栏窗口(不支持win11)"
                                        onClicked: {
                                            window.flags=Qt.Window
                                            window.flags=window_top.checked? Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint|Qt.Window : Qt.FramelessWindowHint|Qt.Window
                                        }
                                    }
                                    CCheckBox{
                                        id:fresh_top
                                        transformOrigin: Item.TopLeft
                                        y:300
                                        height: 18
                                        font.pixelSize: 11
                                        text:"刷新最上层(与其他窗口设置不兼容)"
                                    }
                                }
                            }

                        }
                    }
                }
            }
            Item{//设置
                x:0
                y:menuItems.height-52
                ImaButton{//置顶
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
                }
                ImaButton{//暂停
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
                }
                ImaButton{//锁定
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
                }
                ImaButton{//同步时间
                    radiusBg: 0
                    x:75
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
                }
                ImaButton{//重载数据
                    radiusBg: 0
                    x:100
                    width: 25
                    height: 25
                    img:"./images/reread.png"
                    onClicked:
                    {
                        file.read2("./value.txt")
                        menu.visible=false
                    }
                }
                ImaButton{//清除数据
                    img: "./images/clear_.png"
                    x:125
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

                ImaButton{//关于
                    img: "./images/about.png"
                    width:25
                    height:25
                    x:150
                    onClicked: {
                        about.visible=true
                        menu.visible=false
                    }
                    toolTipText:"关于"
                    radiusBg: 0
                    About{
                        id:about
                    }
                }
                Cbutton{
                    width: 25
                    height: 25
                    x:175
                    font.pixelSize: 17
                    text:">"
                    onClicked: {
                        menu.visible=false
                        mstg_window.visible=false
                    }
                }


                Item{//第二行
                    y:25
                    ImaButton{//退出
                        radiusBg: 0
                        width: 25
                        height: 25
                        img:"./images/exit.png"
                        danger: true
                        onClicked:
                        {
                            mstg_window.save()
                            file.save()
                            Qt.quit()
                        }
                    }
                    ImaButton{//保存按钮
                        width: 25
                        height: 25
                        img: "./images/save.png"
                        x:25
                        onClicked:
                        {
                            mstg_window.save()
                            file.save()
                        }
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
                            mstg_window.visible=false
                        }
                        toolTipText:"隐藏窗口"
                        radiusBg: 0
                    }
                    ImaButton{//不保存并退出按钮
                        width: 25
                        height: 25
                        img: "./images/exit_not_save.png"
                        x:75
                        onClicked: Qt.exit(0)
                        danger:true
                        radiusBg: 0
                    }
                    Cbutton{//窗口上移
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
                        radiusBg: 0
                    }
                    Cbutton{//窗口下移
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
                        radiusBg: 0
                    }
                    Cbutton{//窗口左移
                        width: 25
                        height: 25
                        x:150
                        text: "<"
                        font.pixelSize: 25
                        onClicked:
                        {
                            window.x-=1
                        }
                        radiusBg: 0
                    }
                    Cbutton{//窗口右移
                        width: 25
                        height: 25
                        x:175
                        text: ">"
                        font.pixelSize: 25
                        onClicked:
                        {
                            window.x+=1
                        }
                        radiusBg: 0
                    }
                }
            }
        }
    }
}

