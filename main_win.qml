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
    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    width:win.width*win.scale
    height:win.height*win.scale
    color: "transparent"
    opacity: window_opa.value*0.99+0.01

    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height

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
        anchors.fill: parent
        border.width: border_width.value*window.height/2
        radius:border_radiu.value*window.height/2
        border.color:Qt.rgba(color_border.r,color_border.g,color_border.b,color_border.a)
        color:Qt.rgba(color_back.r,color_back.g,color_back.b,color_back.a)

    }
    // Rectangle{//文字
    //     id:win
    //     transformOrigin: Item.TopLeft
    //     width:window_width.value*240+40
    //     height:window_height.value*100+10
    //     color: "#00000000"
    //     scale:window_scale.value*80.9+0.01

    //     Text{
    //         id:time_text
    //         anchors.centerIn:  parent
    //         property string type:"hh:mm:ss"
    //         font.pixelSize:text_size.value*100+5
    //         color:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
    //         Timer{
    //             id:refresh
    //             interval: 10
    //             property int auto_save_delt:0
    //             onTriggered:
    //             {
    //                 if(auto_save.checked)
    //                 {
    //                     auto_save_delt++
    //                     if(auto_save_delt==7200)
    //                     {
    //                         auto_save_delt=0
    //                         file.save()
    //                     }
    //                 }

    //                 if(h_type.checked) time_text.text=Qt.formatDateTime(new Date(), h_type_t.text)
    //                 else{
    //                     var h,m,s,y,M,z,d;
    //                     h=Number(Qt.formatDateTime(new Date(),"hh"))
    //                     m=Number(Qt.formatDateTime(new Date(),"mm"))
    //                     s=Number(Qt.formatDateTime(new Date(),"ss"))+delT.delT
    //                     z=Qt.formatDateTime(new Date(),"zzz")
    //                     if(s<0)
    //                     {
    //                         m--
    //                         s+=60
    //                         if(m<0)
    //                         {
    //                             h--
    //                             m+=60
    //                             if(h<0)
    //                             {
    //                                 h+=24
    //                             }
    //                         }
    //                     }
    //                     else if(s>=60)
    //                     {
    //                         m++
    //                         s-=60
    //                         if(m>=60)
    //                         {
    //                             h++
    //                             m-=60
    //                             if(h>=24)
    //                             {
    //                                 h-=24
    //                             }
    //                         }
    //                     }
    //                     if(s<10)
    //                         s="0"+s
    //                     if(m<10)
    //                         m="0"+m
    //                     if(h<10)
    //                         h="0"+h
    //                     time_text.text=h+":"+m
    //                     if(show_type_ss.checked)
    //                     {
    //                         time_text.text+=":"+s
    //                         if(show_type_zzz.checked)
    //                             time_text.text+=":"+z
    //                     }
    //                    }
    //                 if(fresh_top.checked)
    //                 {
    //                     window.flags=Qt.FramelessWindowHint
    //                     window.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    //                 }
    //             }
    //             running: false
    //             repeat: true
    //         }
    //     }
    //     MouseArea{
    //         anchors.fill: parent
    //         acceptedButtons: Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
    //         onClicked: (event)=>{
    //                        if(event.button===Qt.LeftButton) menu.visible=false
    //                        else if(event.button===Qt.RightButton)
    //                        {
    //                            menu.x=window.x+mouseX*win.scale
    //                            menu.y=window.y+mouseY*win.scale
    //                            if(menu.x+menu.width>sys_width) menu.x-=menu.width
    //                            if(menu.y+menu.height>sys_height) menu.y-=menu.height
    //                            menu.visible=true
    //                        }
    //                        else if(event.button===Qt.MiddleButton && time_pauce.checked)
    //                            refresh.running=!refresh.running
    //                    }
    //         onWheel:(wheel)=>{
    //                     if(true)
    //                     {
    //                         if(wheel.angleDelta.y>0) win.scale+=0.1
    //                         else if(wheel.angleDelta.y<0)
    //                         {
    //                             if(win.scale>0.2)  win.scale-=0.1
    //                         }
    //                         window_scale.setValue((win.scale-0.01)/20.9)
    //                     }
    //                 }
    //     }
    // }

    // GFile{//文件操作
    //     id:file
    //     function save(){//正常保存
    //         file.save2("./value.txt")
    //     }
    //     function save2(b){
    //         var a=color_text.r.toString()+","+color_text.g.toString()+","+color_text.b.toString()+","+color_text.a.toString()+","   //背景颜色
    //         a+=color_border.r.toString()+","+color_border.g.toString()+","+color_border.b.toString()+","+color_border.a.toString()+","      //文字颜色
    //         a+=color_back.r.toString()+","+color_back.g.toString()+","+color_back.b.toString()+","+color_back.a.toString()+","      //边框颜色
    //         a+=window_opa.value.toString()+","                                                                       //透明度
    //         a+=window_width.value.toString()+","                                                                             //宽度
    //         a+=window_height.value.toString()+","                                                                             //高度
    //         a+=border_width.value.toString()+","                                                                             //边框宽度
    //         a+=border_radiu.value.toString()+","                                                                            //圆角大小
    //         a+=text_size.value.toString()+","                                                                       //字体大小
    //         a+=time_text.anchors.horizontalCenterOffset+","                                                      //文字水平偏移
    //         a+=time_text.anchors.verticalCenterOffset+","                                                        //文字竖直偏移
    //         a+=text_bord.checked+","                                                                                      //是否加粗
    //         a+=window_top.checked+","                                                                                     //是否置顶
    //         a+=time_pauce.checked+","                                                                                  //是否允许暂停
    //         a+=window_lock.checked+","                                                                                    //是否锁定
    //         file.source=b
    //         file.write(a)
    //     }
    //     function read_(){//判断是否是第一次启动
    //         var a=0
    //         file.create("./")
    //         file.source="./is.txt"
    //         if(file.is(file.source))
    //         {
    //             if(file.read()==="true")//不是第一次启动
    //                 file.read2("./value.txt")//读取保存的状态
    //         }
    //         if(a==0)//是第一次启动
    //         {
    //             file.source="./is.txt"
    //             file.write("true")
    //             file.save()//保存当前状态
    //         }
    //     }
    //     function read2(a){//读取保存的状态
    //         file.source=a
    //         var s=file.read(),r_,g_,b_,a_
    //         r_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         g_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         b_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         a_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         color_text.setColor(r_,g_,b_,a_)                                    //文字颜色
    //         r_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         g_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         b_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         a_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         color_border.setColor(r_,g_,b_,a_)                                    //边框颜色
    //         r_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         g_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         b_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         a_=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         color_back.setColor(r_,g_,b_,a_)                                    //背景颜色
    //         window_opa.setValue(Number(s.slice(0,s.indexOf(","))))           //透明度
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         window_width.setValue(s.slice(0,s.indexOf(",")))                         //宽度
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         window_height.setValue(s.slice(0,s.indexOf(",")))                         //高度
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         border_width.setValue(s.slice(0,s.indexOf(",")))                         //边框宽度
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         border_radiu.setValue(s.slice(0,s.indexOf(",")))                        //圆角大小
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         text_size.setValue(s.slice(0,s.indexOf(",")))                   //字体大小
    //         s=s.slice(s.indexOf(",")+1,s.length)                            //文字水平偏移
    //         time_text.anchors.horizontalCenterOffset=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)                            //文字竖直偏移
    //         time_text.anchors.verticalCenterOffset=s.slice(0,s.indexOf(","))
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         text_bord.checked=s.slice(0,s.indexOf(","))=="true" ? true:false      //是否加粗
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         window_top.checked=s.slice(0,s.indexOf(","))=="true" ? true:false     //是否置顶
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         time_pauce.checked=s.slice(0,s.indexOf(","))=="true" ? true:false  //是否允许暂停
    //         s=s.slice(s.indexOf(",")+1,s.length)
    //         window_lock.checked=s.slice(0,s.indexOf(","))=="true" ? true:false    //是否锁定
    //         a=1
    //     }
    // }
    Window{//右键菜单窗口
        id:menu
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 140
        height:100
        color:"transparent"
        onActiveFocusItemChanged: {//失去焦点时隐藏
            if(!activeFocusItem && !color_text.active && !color_border.active && !color_back.active && !saves_window.active && !mstg_window.active)
                visible=false

        }
        Rectangle{//右键菜单窗口背景
            id:menu_back
            width: menu.width
            height:menu.height
            border.width: 2
            border.color: "#80808080"
            transformOrigin: Item.TopLeft

        }


    }
    DragHandler {//按下拖动以移动窗口
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: {
            if (active && !window_lock.checked)
            {
                menu.visible=false
                window.startSystemMove()
            }
        }
    }
}
