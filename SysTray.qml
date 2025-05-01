import QtQuick
import Qt.labs.platform

SystemTrayIcon {//托盘图标
    visible: true
    icon.source: "qrc:/547clock.png"
    id:tray
    onActivated:(reason)=>{
        if(reason==SystemTrayIcon.Trigger)
        {
            $reload.show()
        }
        else if(reason==SystemTrayIcon.DoubleClick)
        {
            $reload.setVisible()
        }
    }
}
