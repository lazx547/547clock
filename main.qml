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
    flags:top?Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint:Qt.FramelessWindowHint
    width:owidth*win.scale
    height:oheight*win.scale
    color: "transparent"
    opacity: 1

    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height
    property bool lock:false
    property bool top:top_set.checked
    property color topic_color:"#2080f0"
    property int owidth:140
    property int oheight:40
    property color font_color:"#2080f0"
    property int border_width:0
    property color border_color:"#000000"
    property color back_color
    property font font_:{
        pixelSize: 30
        family: "微软雅黑"
        bold: false
    }

    function restart(){
        file.save()
        mstg_window.save()
        $reload.full()
    }
    function show(){
        file.read2("./value.txt")
        mstg_window.read()
        window.visible=true
    }
    onActiveFocusItemChanged: {//失去焦点时隐藏
        if(!activeFocusItem && !menu.active)
            menu.visible=false

    }
    Timer{//初始化计时器
        id:timer_set
        interval: 10
        property bool f:true//是否是第一次循环
        property bool f2:true//是否读取保存的状态
        running: false
        repeat: true
        onTriggered:{
            if(f)
            {
                time_text.text= Qt.formatDateTime(new Date(), "hh:mm:ss");
                f=false
            }
            else
            {
                if(time_text.text==Qt.formatDateTime(new Date(), "hh:mm:ss"))
                {
                    refresh.running=true//在整秒时启动刷新时间的计时器，使时间更准确
                    running=false
                    if(f2){
                        f2=false
                        //file.read_()
                        //mstg_window.read()
                        window.x=(sys_width-window.width)/2
                        window.y=(sys_height-window.height)/2
                    }
                }
            }
        }
    }
    Rectangle{//背景
        id:back
        anchors.fill: parent
        border.width:border_width
        border.color:border_color
        color:back_color

    }
    Rectangle{//文字
        id:win
        transformOrigin: Item.TopLeft
        width:owidth.value
        height:oheight.value
        color: "#00000000"
        Text{
            id:time_text
            anchors.centerIn:  parent
            property string type:"hh:mm:ss"
            font:font_
            color:font_color
            Timer{
                id:refresh
                interval: 10
                property int auto_save_delt:0
                onTriggered:
                {
                    time_text.text=Qt.formatDateTime(new Date(),"hh:mm:ss")
                    /*
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
                */}
                running: true
                repeat: true
            }
        }

    }
    MouseArea{
        id:mouse_area
        anchors.fill: parent
        property int dragX
        property int dragY
        property bool dragging
        property int x0
        property int y0
        property bool custon_show
        acceptedButtons: Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
        onWheel:(wheel)=>{
                    if(true)
                    {
                        if(wheel.angleDelta.y>0) win.scale+=0.1
                        else if(wheel.angleDelta.y<0)
                        {
                            if(win.scale>0.2)  win.scale-=0.1
                        }
                    }
                }
        onPressed: (event)=>{
                       if(event.button===Qt.LeftButton)
                       {
                           dragX = mouseX
                           dragY = mouseY
                           dragging = true
                           custon_show=custom.visible
                           custom.opacity=0
                       }
                       x0=window.x
                       y0=window.y
                   }
        onReleased: (event)=>{
                        dragging = false
                        if(window.x==x0 && window.y==y0)
                        {
                            if(event.button===Qt.LeftButton) menu.visible=false
                            else if(event.button===Qt.RightButton)
                            {
                                menu.x=window.x+mouseX
                                menu.y=window.y+mouseY
                                if(menu.x+menu.width>sys_width) menu.x-=menu.width
                                if(menu.y+menu.height>sys_height) menu.y-=menu.height
                                menu.visible=true
                            }
                            else if(event.button===Qt.MiddleButton && time_pauce.checked)
                            refresh.running=!refresh.running
                        }
                        if(custon_show){
                            custom.rePlace()
                            custom.opacity=1
                        }
                    }
        onPositionChanged: {
            if (dragging) {
                window.x += mouseX - dragX
                window.y += mouseY - dragY
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
    SystemTrayIcon {//托盘图标
        visible: true
        icon.source: "qrc:/547clock.png"
        id:tray
        onActivated:(reason)=>{
                        if(reason==SystemTrayIcon.Trigger)
                        {
                            if(top){
                                window.flags=Qt.FramelessWindowHint
                                window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                            }
                            window.visible=true
                        }
                        else if(reason==SystemTrayIcon.DoubleClick)
                        {
                            window.flags=Qt.FramelessWindowHint
                            window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                            window.visible=true
                        }
                    }
    }

    Window{//右键菜单窗口
        id:menu
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 102
        height:122
        color:"transparent"
        minimumWidth: 102
        onActiveFocusItemChanged: {//失去焦点时隐藏
            if(!activeFocusItem)
                visible=false
        }
        onVisibleChanged:
        {
            if(!visible)
            {
                saves_button.seleted=false
                width=minimumWidth
            }
        }
        Rectangle{//右键菜单窗口背景
            id:menu_back
            width: menu.width
            height:menu.height
            border.width: 1
            border.color: "#80808080"
            transformOrigin: Item.TopLeft
        }
        Item{
            x:1
            y:1
            width: 100
            height: parent.height-2
            Cbutton{
                id:top_set
                type:1
                width: parent.width
                text: "置顶"
                checkable: true
                checked: true
                onClicked: menu.visible=false
            }
            Cbutton{
                id:saves_button
                y:top_set.height
                type:1
                width: parent.width
                text: "加载存档"
                onClicked: {
                    menu.width= menu.width==menu.minimumWidth? menu.minimumWidth+saves_window.width:menu.minimumWidth
                    seleted=menu.width==menu.minimumWidth?false:true
                }
            }
            Cbutton{
                id:custom_button
                y:top_set.height*2
                type:1
                width: parent.width
                text: "个性化"
                checkable: true
                onClicked: {
                    if(!checked)
                    {
                        menu.visible=false
                        custom.unChecked()
                        custom.visible=false
                        mouse_area.custon_show=false
                    }
                    else
                    {
                        menu.visible=false
                        custom.rePlace()
                        custom.visible=true
                    }
                }
            }
            Cbutton{
                y:top_set.height*3
                type:1
                width: parent.width
                text: "设置"
                onClicked: {
                    menu.visible=false
                }
            }
            Cbutton{
                y:top_set.height*4
                type:1
                width: parent.width
                text: "隐藏"
                onClicked: {
                    menu.visible=false
                    window.visible=false
                }
            }
            Cbutton{
                y:top_set.height*5
                type:1
                width: parent.width
                text: "关闭"
                onClicked: {
                    menu.visible=false
                    Qt.exit(0)
                }
            }
        }
        Item {
            id: saves_window
            width: 143+saves_scoll.effectiveScrollBarWidth/2
            height: menu.height
            x:102
            Rectangle{
                anchors.fill: parent
                border.width: 1
                border.color: "#80808080"
            }
            Rectangle{
                x:1
                y:1
                TextArea{
                    id:save_text
                    x:1
                    y:1
                    width: 80
                    height: 20
                    color: "black"
                    padding:2
                    font.pixelSize: 13
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
                    x:80
                    y:1
                    width: 60
                    height: 20
                    text:"保存"
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
                width: 320+effectiveScrollBarWidth
                height:saves_window.height*2-82
                scale: 0.5
                transformOrigin: Item.TopLeft
                contentHeight: saves.height*2
                id:saves_scoll
                Item{
                    width: 160
                    id:saves
                    scale: 2
                    transformOrigin: Item.TopLeft
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
    Window{
        id:custom
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 202
        height:22
        color:"#00000000"
        property var sub_windows:[]
        property var buttons:[]
        property int detect_height:50
        property bool show_above:false

        Component.onCompleted: {
            buttons.push(opacity_button)
            buttons.push(radius_button)
            buttons.push(size_button)
            buttons.push(border_button)
            buttons.push(font_button)
            buttons.push(back_button)
            sub_windows.push(opacity_window)
            sub_windows.push(radius_window)
            sub_windows.push(size_window)
            sub_windows.push(border_window)
            sub_windows.push(font_window)
            sub_windows.push(back_window)
        }
        function unChecked(){
            for(var i=0;i<buttons.length;i++)
                buttons[i].checked=false
        }
        function isSubShow()
        {
            for(var i=0;i<sub_windows.length;i++)
                if(sub_windows[i].visible==true)
                    return true
            return false
        }
        function get_showWindow(){
            for(var i=0;i<sub_windows.length;i++)
                if(sub_windows[i].visible==true)
                    return sub_windows[i]
        }

        function rePlace(){
            x=Math.max(Math.min(window.x+window.width/2-width/2,sys_width-5),5)
            custom.y=window.y+window.height+5
            if((isSubShow()?window.y+window.height+5+height+5+get_showWindow().height:window.y+window.height+5+height+5)>sys_height)
            {
                y-=height+10+window.height
                show_above=true
            }
            else
                show_above=false
        }
        Rectangle{
            width: custom.width
            height: 22
            border.color: topic_color
            color:"#f2f2f2"
        }
        Item{
            x:1
            y:1
            width: custom.width-2
            height: custom.height-2
            Rectangle{
                width: 8
                height: 20
                color: topic_color
                MouseArea {
                    id:drag_detect
                    anchors.fill: parent
                    property bool dragging
                    onPressed: {
                        dragging = true
                    }
                    onReleased: {
                        dragging = false
                    }
                }
            }
            Cbutton{
                id:opacity_button
                x:10
                type:2
                width: 20
                height: 20
                onClicked: {
                    custom.unChecked()
                    checked=true
                }

                seleted: checked
                img:"./images/opacity.png"
                Window{
                    id:opacity_window
                    opacity: custom.opacity
                    visible:custom.visible?opacity_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+26
                    width: 184
                    height:22
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        x:3
                        y:3
                        width: 179
                        height: 16
                        text: "透明度"
                        text_width: 43
                        minValue: 1
                        maxValue: 100
                        onValueChanged: window.opacity=value/100
                    }
                }
            }
            Cbutton{
                id:radius_button
                x:30
                type:2
                width: 20
                height: 20
                onClicked: {
                    custom.unChecked()
                    checked=true
                }

                seleted: checked
                img:"./images/radius.png"
                Window{
                    id:radius_window
                    opacity: custom.opacity
                    visible:custom.visible?radius_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+26
                    width: 184
                    height:22
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        x:3
                        y:3
                        width: 179
                        height: 16
                        text: "圆角"
                        text_width: 30
                        minValue: 0
                        maxValue: oheight/2+1
                        onValueChanged: back.radius=value
                        Component.onCompleted: setValue(0)
                    }
                }
            }
            Cbutton{
                id:size_button
                x:50
                type:2
                width: 20
                height: 20
                seleted: checked
                onClicked: {
                    custom.unChecked()
                    checked=true
                }
                img:"./images/size.png"
                Window{
                    id:size_window
                    opacity: custom.opacity
                    visible:custom.visible?size_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+26
                    width: 184
                    height:42
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        x:3
                        y:3
                        width: 179
                        height: 16
                        text: "宽度"
                        text_width: 30
                        minValue: 10
                        maxValue: 250
                        reset:140
                        Component.onCompleted: setValue(reset)
                        onValueChanged: window.owidth=value
                    }
                    CscrollBar{
                        x:3
                        y:23
                        width: 179
                        height: 16
                        text: "高度"
                        text_width: 30
                        minValue: 5
                        maxValue: 150
                        reset: 40
                        Component.onCompleted: setValue(reset)
                        onValueChanged: window.oheight=value
                    }
                }
            }
            Cbutton{
                id:border_button
                x:70
                type:2
                width: 20
                height: 20
                onClicked: {
                    custom.unChecked()
                    checked=true
                }

                seleted: checked
                img:"./images/border.png"
                Window{
                    id:border_window
                    opacity: custom.opacity
                    visible:custom.visible?border_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+26
                    width: 214
                    height:102
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        x:3
                        y:3
                        width: 209
                        height: 16
                        text: "边框大小"
                        text_width: 60
                        minValue: 0
                        maxValue: window.oheight/2+1
                        Component.onCompleted: setValue(0)
                        onValueChanged: border_width=value
                    }
                    ColorPickerItem{
                        id:border_color_picker
                        y:22
                        x:3
                        onColor_Changed: border_color=color_
                    }
                }
            }

            Cbutton{
                id:font_button
                x:90
                type:2
                width: 20
                height: 20
                onClicked: {
                    custom.unChecked()
                    checked=true
                }
                seleted: checked
                img:"./images/font.png"
                Window{
                    id:font_window
                    opacity: custom.opacity
                    visible:custom.visible?font_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+26
                    width: 214
                    height:122
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        color:"#f2f2f2"
                        border.color: topic_color
                    }
                    Cbutton{
                        x:1
                        y:1
                        width: 20
                        height: 20
                        type:2
                        img:"./images/bord.png"
                        font.bold: true
                        checkable: true
                        seleted: checked
                        onCheckedChanged: font_.bold=checked
                    }

                    CscrollBar{
                        x:23
                        y:3
                        width: 189
                        height: 16
                        text: "大小"
                        text_width: 30
                        minValue: 1
                        maxValue: 180
                        Component.onCompleted: setValue(30)
                        onValueChanged: font_.pixelSize=value
                    }
                    ColorPickerItem{
                        id:font_color_picker
                        y:22
                        x:3
                        onColor_Changed: font_color=color_
                    }
                    ComboBox {
                        id: font_combo
                        x:3
                        y:100
                        height: 20
                        transformOrigin: Item.TopLeft
                        model: Qt.fontFamilies()
                        currentIndex: model.indexOf(font_.family)
                    }
                    Cbutton{
                        id:up
                        width: 20
                        height: 20
                        x:130
                        y:100
                        rotation: 90
                        text: "<"
                        onClicked:
                            time_text.anchors.verticalCenterOffset-=1
                        radiusBg: 0
                        colorBorder: "#00000000"
                    }
                    Cbutton{
                        id:down
                        width: 20
                        height: 20
                        rotation: 90
                        x:150
                        y:100
                        text: ">"
                        onClicked:
                            time_text.anchors.verticalCenterOffset+=1
                        radiusBg: 0
                        colorBorder: "#00000000"
                    }
                    Cbutton{
                        id:left
                        width: 20
                        height: 20
                        x:170
                        y:100
                        text: "<"
                        onClicked:
                            time_text.anchors.horizontalCenterOffset-=1
                        radiusBg: 0
                        colorBorder: "#00000000"
                    }
                    Cbutton{
                        id:right
                        width: 20
                        height: 20
                        x:190
                        y:100
                        text: ">"
                        onClicked:
                            time_text.anchors.horizontalCenterOffset+=1
                        radiusBg: 0
                        colorBorder: "#00000000"
                    }
                }
            }
            Cbutton{
                id:back_button
                x:110
                type:2
                width: 20
                height: 20
                onClicked: {
                    custom.unChecked()
                    checked=true
                }
                seleted: checked
                img:"./images/back.png"
                Window{
                    id:back_window
                    opacity: custom.opacity
                    visible:custom.visible?back_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+26
                    width: 208
                    height:82
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        color:"#f2f2f2"
                        border.color: topic_color
                    }
                    ColorPickerItem{
                        id:back_color_picker
                        y:3
                        x:3
                        onColor_Changed: back_color=color_
                        Component.onCompleted: setColor(0,0,0,0)
                    }
                }
            }
            Cbutton{
                x:parent.width-20
                type:2
                width: 20
                height: 20
                onClicked: {
                    custom_button.checked=false
                    custom.visible=false
                    custom.unChecked()
                    mouse_area.custon_show=false
                }

                img:"./images/check.png"
            }
        }
        DragHandler {//按下拖动以移动窗口
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active && drag_detect.dragging)
                {
                    custom.startSystemMove()
                }
            }
        }
    }
}
