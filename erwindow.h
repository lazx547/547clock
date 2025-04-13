#ifndef ERWINDOW_H
#define ERWINDOW_H

#include <QWidget>
#include <QPushButton>
#include <QLabel>


class ErWindow : public QWidget
{
    Q_OBJECT
public:
    explicit ErWindow(QWidget *parent = nullptr);

private:
    QPushButton *button;
    QLabel *text;
};

#endif // ERWINDOW_H
