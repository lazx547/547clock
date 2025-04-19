#include "gfile.h"
#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <gfile.h>
#include "erwindow.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_Use96Dpi);
    GFile file;
    file.setSource("./scale.txt");
    QString s=file.read();
    qputenv("QT_SCALE_FACTOR",s.toLatin1());
    file.setSource("./run.ini");
    s=file.read();
    QUrl url(QStringLiteral("./file/main.qml"));
    if(s=="fullscreen"){
        url=QStringLiteral("./file/main_full.qml");
    }

    QGuiApplication app(argc, argv);
    QApplication* app2=new QApplication(argc, argv);
    ErWindow w;
    qmlRegisterType<GFile>("GFile",1,2,"GFile");
    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,&app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
            QCoreApplication::exit(-2);
    }, Qt::QueuedConnection);
    if(!file.is(url.toString())){
        w.show();
    }
    else
    {
        app2->destroyed();
        engine.load(url);
    }
    return app.exec();
}
