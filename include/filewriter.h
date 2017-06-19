#pragma once

#include <QObject>

class FileWriter : public QObject {
    Q_OBJECT
public:
    explicit FileWriter(QObject *parent = 0);

signals:

public slots:
};
