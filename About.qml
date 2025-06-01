import QtQuick

Window{
    id:about
    width: 300
    height: 230
    minimumHeight: height
    maximumHeight: height
    minimumWidth: width
    maximumWidth: width
    Image {
        x:20
        y:10
        width: 70
        height: 70
        source: "./images/sys_Tray.png"
    }
    Text{
        x:90
        y:35
        font.pixelSize: 20
        text:"547clock v0.14.2"
    }
    Image {
        x:20
        y:90
        width: 70
        height: 70
        source: "./images/Qt.png"
    }
    Text{
        x:90
        y:105
        font.pixelSize: 20
        text:"Made with Qt6 (qml)"
    }
    Text {
        x:90
        y:125
        text: "(Desktop Qt 6.8.3 MinGW 64-bit)"
    }
    Cbutton{
        text:"源代码"
        font.pixelSize: 16
        width: 80
        x:30
        y:170
        height: 20
        onClicked: Qt.openUrlExternally("https://github.com/lazx547/547clock")
    }
    Cbutton{
        text:"547官网"
        font.pixelSize: 16
        width: 100
        x:170
        y:170
        height: 20
        onClicked: Qt.openUrlExternally("https://lazx547.github.io")
    }
}
