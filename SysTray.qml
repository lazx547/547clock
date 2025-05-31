import QtQuick
import Qt.labs.platform 1.1
import QtQuick.Controls
Window{
    x:-100
    y:-100
    width: 10
    height:10
    property var win
    SystemTrayIcon {//托盘图标
        id:root
        visible: true
        icon.source: "qrc:/547clock.png"
        onActivated:(reason)=>{
                        if (reason === SystemTrayIcon.Context) {
                            menu.open()
                        } else {
                            win.visible=true
                            win.raise()
                        }
                    }
        menu:Menu{
            id:menu
            MenuItem{
                text:"幽灵模式"
                checkable: true
                onCheckedChanged: {
                    if(checked)
                        win.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint| Qt.WindowTransparentForInput
                    else
                        win.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                }
            }
            MenuItem{
                text: "重载"
                onTriggered:win.restart()
            }
            MenuItem{
                text: "设置"
                onTriggered:win.show_setting()
            }
            MenuItem{
                text: "退出"
                onTriggered: Qt.quit()
            }
        }
    }
}

