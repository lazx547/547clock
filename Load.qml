import QtQuick
import GFile 1.2

Item {
    property var fullwin
    property var winwin
    property bool type:true
    function full(){
        fullwin.visible=true
        winwin.visible=false
        type=false
        file.write("full")
    }
    function win(){
        winwin.visible=true
        fullwin.visible=false
        type=true
        file.write("win")
    }
    function setVisible(){
        if(type)
            winwin.visible=!winwin.visible
    }
    function show(){
        if(type)
        {
            winwin.flags=Qt.FramelessWindowHint
            winwin.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        }
        else
        {
            fullwin.visible=true
        }
    }

    GFile{
        id:file
    }

    Component.onCompleted: {
        var Win=Qt.createComponent("./main_win.qml")
        winwin=Win.createObject()
        winwin.visible=false
        var Full=Qt.createComponent("./main_full.qml")
        fullwin=Full.createObject()
        fullwin.visible=false
        file.source="./run.int"
        var a=file.read()
        if(a=="full")
        {
            type=false
            fullwin.show()
        }
        else
        {
            type=true
            winwin.show()
        }
    }
}
