import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt.labs.platform
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic
import GFile 1.2

Window{
    id: window
    flags:top?Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint:Qt.FramelessWindowHint
    width:owidth*win.scale
    height:oheight*win.scale
    color: "transparent"
    opacity: 1
    visible: false

    property var sysTray:SysTray{win:window}
    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height
    property bool lock:lock_set.checked
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

    function show_setting()
    {
        setting.visible=true
    }

    function restart(){
        timer_set.f=true
        timer_set.f2=true
        timer_set.running=true
    }

    onActiveFocusItemChanged: {//失去焦点时隐藏
        if(!activeFocusItem && !menu_.active)
            menu_.visible=false

    }
    Timer{//初始化计时器
        id:timer_set
        interval: 100
        property bool f:true//是否是第一次循环
        property bool f2:true//是否读取保存的状态
        running: true
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
                        file.read_()
                        setting.read()
                        window.visible=true
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
        anchors.centerIn: parent
        width:owidth.value
        height:oheight.value
        color: "#00000000"
        Text{
            id:time_text
            anchors.centerIn: win
            property string type:"hh:mm:ss"
            font:font_
            color:font_color
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
                            setting.save()
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
                    if(refresh_top.checked)
                    {
                        window.raise()
                    }
                }
                running: false
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
                    if(!lock)
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
                            if(event.button===Qt.LeftButton) menu_.visible=false
                            else if(event.button===Qt.RightButton)
                            {
                                menu_.x=window.x+mouseX
                                menu_.y=window.y+mouseY
                                if(menu_.x+menu_.width>sys_width) menu_.x-=menu_.width
                                if(menu_.y+menu_.height>sys_height) menu_.y-=menu_.height
                                menu_.visible=true
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
            if (!lock&&dragging) {
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
            var a=font_color_picker.r.toString()+","+font_color_picker.g.toString()+","+font_color_picker.b.toString()+","+font_color_picker.a.toString()+","   //背景颜色
            a+=border_color_picker.r.toString()+","+border_color_picker.g.toString()+","+border_color_picker.b.toString()+","+border_color_picker.a.toString()+","      //文字颜色
            a+=back_color_picker.r.toString()+","+back_color_picker.g.toString()+","+back_color_picker.b.toString()+","+back_color_picker.a.toString()+","      //边框颜色
            a+=window_opacity.value.toString()+","                                                                       //透明度
            a+=window_width.value.toString()+","                                                                             //宽度
            a+=window_height.value.toString()+","                                                                             //高度
            a+=border_size.value.toString()+","                                                                             //边框宽度
            a+=window_radius.value.toString()+","                                                                            //圆角大小
            a+=font_size.value.toString()+","                                                                       //字体大小
            a+=time_text.anchors.horizontalCenterOffset+","                                                      //文字水平偏移
            a+=time_text.anchors.verticalCenterOffset+","                                                        //文字竖直偏移
            a+=font_bord.checked+","                                                                                      //是否加粗
            a+=top+","                                                                                     //是否置顶
            a+=lock.checked+","                                                                                    //是否锁定
            a+=window.x+","
            a+=window.y+","
            a+=win.scale+","
            file.source=b
            file.write(a)
        }
        function read_(){//判断是否是第一次启动
            var a=0
            file.source="./is.txt"
            if(file.is(file.source))
            {
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
            font_color_picker.setColor(r_,g_,b_,a_)                                    //文字颜色
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            border_color_picker.setColor(r_,g_,b_,a_)                                    //边框颜色
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            back_color_picker.setColor(r_,g_,b_,a_)                                    //背景颜色
            window_opacity.setValue(Number(s.slice(0,s.indexOf(","))))           //透明度
            s=s.slice(s.indexOf(",")+1,s.length)
            window_width.setValue(s.slice(0,s.indexOf(",")))                         //宽度
            s=s.slice(s.indexOf(",")+1,s.length)
            window_height.setValue(s.slice(0,s.indexOf(",")))                         //高度
            s=s.slice(s.indexOf(",")+1,s.length)
            border_size.setValue(s.slice(0,s.indexOf(",")))                         //边框宽度
            s=s.slice(s.indexOf(",")+1,s.length)
            window_radius.setValue(s.slice(0,s.indexOf(",")))                        //圆角大小
            s=s.slice(s.indexOf(",")+1,s.length)
            font_size.setValue(s.slice(0,s.indexOf(",")))                   //字体大小
            s=s.slice(s.indexOf(",")+1,s.length)     //文字水平偏移
            time_text.anchors.horizontalCenterOffset=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)     //文字竖直偏移
            time_text.anchors.verticalCenterOffset=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            font_bord.checked=s.slice(0,s.indexOf(","))=="true" ? true:false      //是否加粗
            s=s.slice(s.indexOf(",")+1,s.length)
            top_set.checked=s.slice(0,s.indexOf(","))=="true" ? true:false     //是否置顶
            s=s.slice(s.indexOf(",")+1,s.length)
            lock_set.checked=s.slice(0,s.indexOf(","))=="true" ? true:false    //是否锁定
            s=s.slice(s.indexOf(",")+1,s.length)
            window.x=Number(s.slice(0,s.indexOf(",")))
            s=s.slice(s.indexOf(",")+1,s.length)
            window.y=Number(s.slice(0,s.indexOf(",")))
            s=s.slice(s.indexOf(",")+1,s.length)
            var b=Number(s.slice(0,s.indexOf(",")))
            if(b<=0.01)
                b=1
            win.scale=b
        }
    }
    Window{//右键菜单窗口
        id:menu_
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 102
        height:142
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
            id:menu__back
            width: menu_.width
            height:menu_.height
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
                onClicked: menu_.visible=false
            }
            Cbutton{
                id:lock_set
                type:1
                y:top_set.height
                width: parent.width*2
                text: "锁定"
                checkable: true
                onClicked: menu_.visible=false
            }
            Cbutton{
                id:saves_button
                y:top_set.height*2
                type:1
                width: parent.width
                text: "存档"
                onClicked: {
                    menu_.width= menu_.width==menu_.minimumWidth? menu_.minimumWidth+saves_window.width:menu_.minimumWidth
                    seleted=menu_.width==menu_.minimumWidth?false:true
                }
            }
            Cbutton{
                id:custom_button
                y:top_set.height*3
                type:1
                width: parent.width
                text: "个性化"
                checkable: true
                onClicked: {
                    if(!checked)
                    {
                        menu_.visible=false
                        custom.unChecked()
                        custom.visible=false
                        mouse_area.custon_show=false
                    }
                    else
                    {
                        menu_.visible=false
                        custom.rePlace()
                        custom.visible=true
                    }
                }
            }
            Cbutton{
                y:top_set.height*4
                type:1
                width: parent.width
                text: "设置"
                onClicked: {
                    menu_.visible=false
                    setting.visible=true
                }
            }
            Cbutton{
                y:top_set.height*5
                type:1
                width: parent.width
                text: "隐藏"
                onClicked: {
                    menu_.visible=false
                    window.visible=false
                }
            }
            Cbutton{
                y:top_set.height*6
                type:1
                width: parent.width
                text: "关闭"
                onClicked: {
                    menu_.visible=false
                    file.save()
                    Qt.exit(0)
                }
            }
        }
        Item {
            id: saves_window
            width: 143+saves_scoll.effectiveScrollBarWidth/2
            height: menu_.height
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
                        im.y=(im.n-1)*20
                        im.parent=saves
                        saves.height=20*im.n
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
                y:25
                width: 320+effectiveScrollBarWidth
                height:saves_window.height*2-62
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
                            sis[i].y-=20
                        }
                        sis.pop()
                        saves.height-=20
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
                        im.y=(n-1)*20
                        im.parent=saves
                    }
                    saves.height=20*a
                }
            }
        }
    }
    Window{
        id:custom
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 202
        height:27
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
            custom.opacity=1
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
            height: 27
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
                height: 25
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
                width: 25
                height: 25
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
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 184
                    height:22
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        id:window_opacity
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
                x:35
                type:2
                width: 25
                height: 25
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
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 184
                    height:22
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        id:window_radius
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
                x:60
                type:2
                width: 25
                height: 25
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
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 184
                    height:42
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        id:window_width
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
                        id:window_height
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
                x:85
                type:2
                width: 25
                height: 25
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
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 214
                    height:102
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        id:border_size
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
                x:110
                type:2
                width: 25
                height: 25
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
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 214
                    height:122
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        color:"#f2f2f2"
                        border.color: topic_color
                    }
                    Cbutton{
                        id:font_bord
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
                        id:font_size
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
                x:135
                type:2
                width: 25
                height: 25
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
                    y:custom.show_above?custom.y-4-height:custom.y+31
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
                x:parent.width-25
                type:2
                width: 25
                height: 25
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
    Window{
        id:setting
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        x:(sys_width-width)/2
        y:(sys_height-height)/2
        width: 406
        height:242
        color:"#00000000"
        function save(){
            file.source="./setting.ini"
            var a
            a=topic_color_picker.r+","+topic_color_picker.g+","+topic_color_picker.b+","+topic_color_picker.a+","
            a+=refresh_top.checked+","
            a+=delT.value+","+h_type_t.text+","+h_type.checked+","+show_type_ss.checked+","+show_type_zzz.checked+","+auto_save.checked+","
            file.write(a)
        }
        function read(){
            file.source="./setting.ini"
            var s=file.read(),r_,g_,b_,a_
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            topic_color_picker.setColor(r_,g_,b_,a_)
            refresh_top.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
            s=s.slice(s.indexOf(",")+1,s.length)
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
            border.color: topic_color
            color:"#f2f2f2"
        }
        Rectangle{
            width: parent.width
            height: 20
            color: topic_color
            Text{
                text:"547clock设置"
                font.pixelSize: 15
            }
            MouseArea {
                anchors.fill: parent
                property int dragX
                property int dragY
                property bool dragging
                onPressed: {
                    dragX = mouseX
                    dragY = mouseY
                    dragging = true
                }
                onReleased: {
                    dragging = false
                }
                onPositionChanged: {
                    if (dragging) {
                        setting.x += mouseX - dragX
                        setting.y += mouseY - dragY
                    }
                }
            }
            Cbutton{
                x:parent.width-20
                y:0
                type:3
                width: 20
                height: 20
                text: "×"
                colorBg: "#00000000"
                colorBorder: "#00000000"
                font.pixelSize: 25
                padding: 0
                topPadding: 0
                onClicked: {
                    setting.visible=false
                }
            }
            Item{
                x:1
                y:20
                Text{
                    text:"主题色"
                    font.pixelSize: 15
                }
                ColorPickerItem{
                    id:topic_color_picker
                    y:20
                    onColor_Changed: topic_color=color_
                    Component.onCompleted: setColor(32/256, 128/256, 240/256,1)
                }
                CCheckBox{
                    id:refresh_top
                    y:105
                    scale: 0.75
                    transformOrigin: Item.TopLeft
                    text: "刷新显示在最上层"
                }
                CscrollBar{
                    id:delT
                    y:135
                    width: 200
                    height: 15
                    text: "时差"
                    minValue: -60
                    maxValue: 60
                    Component.onCompleted: setValue(reset)
                    reset:0
                    property int delT:value
                }
                Rectangle{
                    y:152
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
                    y:177
                    CCheckBox{
                        id:auto_save
                        height: 16
                        transformOrigin: Item.TopLeft
                        font.pixelSize: 15
                        text:"自动保存"
                    }
                    ProgreBar{
                        id:auto_save_pb
                        x:90
                        width: 100
                        percent: refresh.auto_save_delt/7200
                    }
                }
                Cbutton{
                    y:200
                    x:2
                    width: 180
                    height: 20
                    text: "保存"
                    onClicked: setting.save()
                }
                ImaButton{
                    img:"./images/about.png"
                    y:200
                    x:182
                    width: 20
                    height:20
                    onClicked: about.visible=true
                    About{
                        id:about
                    }
                }
            }
            Item{
                x:203
                y:20
                Rectangle{
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
            }
        }
    }
}
