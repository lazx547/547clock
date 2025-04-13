#include "erwindow.h"

ErWindow::ErWindow(QWidget *parent)
    : QWidget{parent}
{
    this->setMaximumSize(300,150);
    this->setMinimumSize(300,150);
    this->setWindowTitle("547clock>程序启动错误");
    button=new QPushButton(this);
    button->setMaximumSize(100,30);
    button->setMinimumSize(100,30);
    button->move(100,100);
    button->setText("确定");
    text=new QLabel("未找到main.qml\n请检查文件完整性\n文件路径：./file/",this);
    text->setMaximumSize(300,80);
    text->setMinimumSize(300,80);
    text->move(0,10);
    text->setAlignment(Qt::AlignCenter);
    QFont font;
    font.setPixelSize(20);
    text->setFont(font);
    connect(button,&QPushButton::clicked,this,[this]{exit(-2);});
}
