import QtQuick
import GFile

Rectangle{
    property var file
    property var par
    property string num:""
    property int n
    property bool type:true
    onTypeChanged: {
        if(type)
        {
            width=160
            b1.x=62
            b2.x=92
            b3.x=122
        }
        else
        {
            width=196
            b1.x=72
            b2.x=112
            b3.x=152
        }
    }

    border.width: 2
    border.color: "#80808080"
    width: 160
    height: 50
    GFile{
        id:afile
    }
    z:-1
    function setc(ss)
    {
        afile.source=ss
        var s=afile.read(),r_,g_,b_,a_
        r_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        g_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        b_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        a_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        sr1.color=Qt.rgba(r_,g_,b_,a_)                                    //文字颜色
        r_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        g_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        b_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        a_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        sr2.color=Qt.rgba(r_,g_,b_,a_)                                    //边框颜色
        r_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        g_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        b_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        a_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        sr3.color=Qt.rgba(r_,g_,b_,a_)
    }

    Timer{
        interval: 10
        onTriggered:setc("./file/saves/"+num+".txt")
        repeat: false
        running: true
    }

    Text{
        x:65
        y:3
        text:num
        font.pixelSize: 17
    }
    Item{
        x:5
        y:5
        width: 51
        height: 40
        Grid {
            id: previwBackground
            anchors.fill: parent
            rows: 11
            columns: 11
            clip: true

            property real cellWidth: width / columns
            property real cellHeight: height / rows

            Repeater {
                model: parent.columns * parent.rows

                Rectangle {
                    width: previwBackground.cellWidth
                    height: width
                    color: (index % 2 == 0) ? "gray" : "transparent"
                }
            }
        }
        Rectangle{
            id:sr1
            width: 17
            height: 40
        }
        Rectangle{
            id:sr2
            width: 17
            height: 40
            x:17
        }
        Rectangle{
            id:sr3
            width: 17
            height: 40
            x:34
        }
    }
    ImaButton{
        id:b1
        x:62
        radiusBg: 0
        width: 30
        height: 20
        y:25
        img:"./images/reset.png"
        toolTipText: "加载"
        onClicked: file.read2("./file/saves/"+num+".txt")
    }
    ImaButton{
        id:b2
        x:92
        radiusBg: 0
        width: 30
        height: 20
        y:25
        img:"./images/save.png"
        toolTipText:  "保存"
        onClicked: {
            file.save2("./file/saves/"+num+".txt")
            setc("./file/saves/"+num+".txt")
        }
    }
    ImaButton{
        id:b3
        x:122
        radiusBg: 0
        width: 30
        height: 20
        y:25
        img:"./images/del.png"
        toolTipText:  "删除"
        onClicked: {
            afile.del()
            par.remove(n)
        }
    }
}
