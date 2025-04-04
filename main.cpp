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



    QGuiApplication app(argc, argv);
    QApplication app2(argc, argv);
    ErWindow w;
    qmlRegisterType<GFile>("GFile",1,2,"GFile");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("./file/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,&app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
            QCoreApplication::exit(-2);
    }, Qt::QueuedConnection);
    if(!file.is(url.toString())){
        w.show();
    }
    else
    {
        engine.load(url);
    }
    return app.exec();
}
